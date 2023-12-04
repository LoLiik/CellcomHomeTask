//
//  PopularMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskModels

public protocol PopularMoviePagesProvider: AnyObject {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
}
