//
//  NetworkWorker+SessionProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

extension NetworkWorker: SessionProvider {
    public func generateSession(token: RequestToken, completion: @escaping (Result<Session, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        let urlPath = createUrlWithApiKey(Paths.createSession)
        guard let url = urlPath.url else { return nil }
        return post(url: url, object: token, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static let createSession = "https://api.themoviedb.org/3/authentication/session/new"
}

