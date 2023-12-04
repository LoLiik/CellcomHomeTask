//
//  FavoriteMovieUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskModels

public protocol FavoriteMovieUpdater: AnyObject {
    func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
}
