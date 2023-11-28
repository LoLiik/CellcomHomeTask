//
//  NetworkWorker+RequestTokenProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: RequestTokenProvider {
    public func generateRequestToken(completion: @escaping (Result<RequestToken, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        let urlPath = createUrlWithApiKey(Paths.createRequestToken)
        guard let url = urlPath.url else { return nil }
        return fetch(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static let createRequestToken = "https://api.themoviedb.org/3/authentication/token/new"
}
