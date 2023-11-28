//
//  CurrentlyBroadcastMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels

public protocol CurrentlyBroadcastMoviePagesProvider: AnyObject {
    func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
