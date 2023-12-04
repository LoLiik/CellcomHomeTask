//
//  AuthWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation
import UIKit
import CellcomHometaskModels
import CellcomHometaskProtocols

public class UpdatableCancebleTaskProxy {
    public var currentTask: CancelableDataLoadingTask?
}

extension UpdatableCancebleTaskProxy: DataLoadingTaskUpdatable { }

extension UpdatableCancebleTaskProxy: CancelableDataLoadingTask {
    public func cancel() {
        currentTask?.cancel()
    }
}

public final class AuthWorkerFactory {
    public static func build(
        userAuthPermissionRequestWorker: UserAuthPermissionRequestWorkerProtocol,
        sessionUpdater: SessionUpdater
    ) -> AuthWorkerProtocol {
        return AuthWorker(
            authProvider: NetworkWorker(),
            userAuthPermissionRequestWorker: userAuthPermissionRequestWorker,
            sessionUpdater: sessionUpdater
        )
    }
}

/// Responsible for authentication process
/// https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id
public final class AuthWorker {
    private let authProvider: AuthProvider
    private let userAuthPermissionRequestWorker: UserAuthPermissionRequestWorkerProtocol
    private let sessionUpdater: SessionUpdater
    
    init(
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
