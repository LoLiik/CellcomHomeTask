//
//  NetworkWorker+MyFavoritesMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskModels
import CellcomHometaskProtocols

extension NetworkWorker: MyFavoriteMoviePagesProvider {
    @discardableResult
    public func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        guard let sessionId = Config.sessionId else {
            completion(.failure(.authDenied))
            return nil
        }
        
        guard let accountId = Config.accountId else {
            completion(.failure(.noAccountId))
            return nil
        }
        
        let myFavoriteMovieUrlPath = Paths.createMyFavoriteMoviesUrlPath(with: accountId)
        let urlPath = createUrlWithApiKey(myFavoriteMovieUrlPath)
            .addParameter(parameterName: "page", value: page)
            .addParameter(parameterName: "session_id", value: sessionId)
        guard let url = urlPath.url else { return nil }
        return fetch(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static func createMyFavoriteMoviesUrlPath(with accountId: Int) -> String {
        "\(createAddMovieToFavoriteMoviesUrlPath(with: accountId))/movies"
    }
}

