//
//  NetworkWorker+FavoriteMovieUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: FavoriteMovieUpdater {
    public func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        guard let sessionId = Config.sessionId else {
            completion(.failure(.authDenied))
            return nil
        }
        
        guard let accountId = Config.accountId else {
            completion(.failure(.noAccountId))
            return nil
        }
        let movieId = FavoriteMovie(id: movieId, isFavorite: isFavorite)
        let myFavoriteMovieUrlPath = Paths.createAddMovieToFavoriteMoviesUrlPath(with: accountId)
        let urlPath = createUrlWithApiKey(myFavoriteMovieUrlPath)
            .addParameter(parameterName: "session_id", value: sessionId)
        guard let url = urlPath.url else { return nil }
        return post(url: url, object: movieId, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static func createAddMovieToFavoriteMoviesUrlPath(with accountId: Int) -> String {
        "https://api.themoviedb.org/3/account/\(accountId)/favorite"
    }
}
