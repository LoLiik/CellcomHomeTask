//
//  UserAuthPermissionRequestWorkerProtocol.swift
//  CellcomHometaskProtocols
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import Foundation
import CellcomHometaskModels

public protocol UserAuthPermissionRequestWorkerProtocol: AnyObject {
    func requestUserAuthPermission(url: URL, completion: @escaping (Result<Void, MovieFetchingError>) -> Void )
}

public protocol AuthWorkerProtocol: AnyObject {
    func startAuthentication(updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void)
}

public protocol DataLoadingTaskUpdatable: AnyObject {
    var currentTask: CancelableDataLoadingTask? { get set }
}
