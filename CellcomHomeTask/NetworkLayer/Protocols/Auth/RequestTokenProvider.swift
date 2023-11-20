//
//  RequestTokenProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol RequestTokenProvider: AnyObject {
    func generateRequestToken(completion: @escaping (Result<RequestToken, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
