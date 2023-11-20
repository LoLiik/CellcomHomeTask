//
//  MyFavoritesMoviesProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol MyFavoriteMoviesProvider: AnyObject {
    func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
