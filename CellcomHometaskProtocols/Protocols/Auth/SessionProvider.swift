//
//  SessionProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels

public protocol SessionProvider: AnyObject {
    func generateSession(token: RequestToken, completion: @escaping (Result<Session, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
