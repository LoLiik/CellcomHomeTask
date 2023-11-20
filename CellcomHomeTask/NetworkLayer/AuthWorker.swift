//
//  AuthWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation
import UIKit

public protocol UserAuthPermissionRequestWorkerProtocol: AnyObject {
    func requestUserAuthPermission(url: URL, completion: @escaping (Result<Void, MovieFetchingError>) -> Void )
}


public protocol AuthWorkerProtocol: AnyObject {
    func startAuthentication(completion: @escaping (Result<Void, MovieFetchingError>) -> Void)
}

/// Responsible for authentication process
/// https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id
public final class AuthWorker {
    private let authProvider: AuthProvider
    private let userAuthPermissionRequestWorker: UserAuthPermissionRequestWorkerProtocol
    private let sessionUpdater: SessionUpdater
    
    public init(
        authProvider: AuthProvider,
        userAuthPermissionRequestWorker: UserAuthPermissionRequestWorkerProtocol,
        sessionUpdater: SessionUpdater
    ) {
        self.authProvider = authProvider
        self.userAuthPermissionRequestWorker = userAuthPermissionRequestWorker
        self.sessionUpdater = sessionUpdater
    }
    
    private func approveToken(_ requestToken: RequestToken, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        let urlPath = "\(NetworkWorker.Paths.userAuthPermission)\(requestToken.token)"
        guard let url = URL(string: urlPath) else { return }
        userAuthPermissionRequestWorker.requestUserAuthPermission(url: url) { [weak self] result in
            switch result {
            case .success:
                self?.generateSessionId(with: requestToken, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func generateSessionId(with requestToken: RequestToken, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        _ = authProvider.generateSession(token: requestToken) { [weak self] result in
            switch result {
            case let .success(session):
                self?.sessionUpdater.updateSessionId(session.id)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension AuthWorker: AuthWorkerProtocol {
    public func startAuthentication(completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        _ = authProvider.generateRequestToken { [weak self] tokenResult in
            switch tokenResult {
            case let .success(requestToken):
                self?.approveToken(requestToken, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkWorker.Paths {
    static let userAuthPermission = "https://www.themoviedb.org/authenticate/"
}
