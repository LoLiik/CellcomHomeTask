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
    func startAuthentication(updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void)
}

public protocol DataLoadingTaskUpdatable: AnyObject {
    var currentTask: DataLoadingTask? { get set }
}

public class UpdatableCancebleTaskProxy {
    public var currentTask: DataLoadingTask?
}

extension UpdatableCancebleTaskProxy: DataLoadingTaskUpdatable { }

extension UpdatableCancebleTaskProxy: DataLoadingTask {
    public func cancel() {
        currentTask?.cancel()
    }
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
    
    private func approveToken(_ requestToken: RequestToken, updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        let urlPath = "\(NetworkWorker.Paths.userAuthPermission)\(requestToken.token)"
        guard let url = URL(string: urlPath) else { return }
        userAuthPermissionRequestWorker.requestUserAuthPermission(url: url) { [weak self] result in
            switch result {
            case .success:
                self?.generateSessionId(with: requestToken, updatableTask: updatableTask, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func generateSessionId(with requestToken: RequestToken, updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        let currentTask = authProvider.generateSession(token: requestToken) { [weak self] result in
            switch result {
            case let .success(session):
                self?.sessionUpdater.updateSessionId(session.id)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
        updatableTask.currentTask = currentTask
    }
}

extension AuthWorker: AuthWorkerProtocol {
    public func startAuthentication(updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        let currentTask = authProvider.generateRequestToken { [weak self] tokenResult in
            switch tokenResult {
            case let .success(requestToken):
                self?.approveToken(requestToken, updatableTask: updatableTask, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
        updatableTask.currentTask = currentTask
    }
}

extension NetworkWorker.Paths {
    static let userAuthPermission = "https://www.themoviedb.org/authenticate/"
}
