//
//  NetworkWorker+PopularMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

extension NetworkWorker: PopularMoviePagesProvider {
    public func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        let urlPath = createUrlWithApiKey(Paths.popularMovies).addParameter(parameterName: "page", value: page)
        guard let url = urlPath.url else { return nil }
        return fetch(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static var popularMovies: String { "https://api.themoviedb.org/3/movie/popular" }
}
