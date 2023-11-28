//
//  NetworkWorker+CurrentlyBroadcastMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: CurrentlyBroadcastMoviePagesProvider {
    public func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        let urlPath = createUrlWithApiKey(Paths.currentlyBroadcastMoviesUrlPath).addParameter(parameterName: "page", value: page)
        guard let url = urlPath.url else { return nil }
        return fetch(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static var currentlyBroadcastMoviesUrlPath: String { "https://api.themoviedb.org/3/movie/now_playing" }
}
