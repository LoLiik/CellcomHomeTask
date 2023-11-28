//
//  MoviesProviderFacade.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

public protocol MoviesProvider: AnyObject {
    var movies: [Movie] { get }
    var haveMorePages: Bool { get }
    func resetData()
    func fetchMovies(completion: @escaping (Result<Void, MovieFetchingError>) -> Void) -> DataLoadingTask?
}

protocol MovieListTypeSelectionDelegate: AnyObject {
    func movieListTypeWasSelected(_ movieListType: MovieListType, shouldResetData: Bool)
}

class MoviesProviderFacade {
    var currentMovieListType: MovieListType = .popular
    
    private let popularMoviesProvider: MoviesProvider
    private let currentBroadcastMoviesProvider: MoviesProvider
    private let myFavoriteMoviesProvider: MoviesProvider
    
    private var currentMovieProvider: MoviesProvider {
        switch currentMovieListType {
        case .popular:
            popularMoviesProvider
        case .currentBroadcast:
            currentBroadcastMoviesProvider
        case .myFavorites:
            myFavoriteMoviesProvider
        }
    }
    
    init(popularMoviesProvider: MoviesProvider, currentBroadcastMoviesProvider: MoviesProvider, myFavoriteMoviesProvider: MoviesProvider) {
        self.popularMoviesProvider = popularMoviesProvider
        self.currentBroadcastMoviesProvider = currentBroadcastMoviesProvider
        self.myFavoriteMoviesProvider = myFavoriteMoviesProvider
    }
}

extension MoviesProviderFacade: MoviesProvider {
    var movies: [Movie] {
        currentMovieProvider.movies
    }
    
    var haveMorePages: Bool {
        currentMovieProvider.haveMorePages
    }
    
    func resetData() {
        currentMovieProvider.resetData()
    }
    
    func fetchMovies(completion: @escaping (Result<Void, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return currentMovieProvider.fetchMovies(completion: completion)
    }
}

extension MoviesProviderFacade: MovieListTypeSelectionDelegate {
    func movieListTypeWasSelected(_ movieListType: MovieListType, shouldResetData: Bool) {
        self.currentMovieListType = movieListType
        if shouldResetData {
            currentMovieProvider.resetData()
        }
    }
}
