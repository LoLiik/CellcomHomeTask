//
//  NetworkWorker+GuestSessionProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: GuestSessionProvider {
    public func generateGuestSession(completion: @escaping (Result<GuestSession, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        let urlPath = createUrlWithApiKey(Paths.guestSession)
        guard let url = urlPath.url else { return nil }
        return fetch(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static let guestSession = "https://api.themoviedb.org/3/authentication/guest_session/new"
}
