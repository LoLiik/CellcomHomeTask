//
//  MoviesListViewModel.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

enum MovieListType {
    case popular
    case myFavorites
    case currentBroadcast
}

public protocol DataLoadingTask: AnyObject {
    func cancel()
}

protocol MoviesListViewModelProtocol: AnyObject {
    var currentPage: Int { get }
    var movies: [Movie] { get }
    var totalPagesCount: Int { get }
    var currentListType: MovieListType { get set }
    func viewLoaded()
    func setup(cell: MovieListCell, at: IndexPath)
}

final class MoviesListViewModel: MoviesListViewModelProtocol {
    weak var view: MoviesListView?
    private let listMoviesProvider: ListMoviesProvider
    private let lowResPosterProvider: LowResImageProvider
    
    private(set) var currentPage: Int = 1
    private(set) var movies: [Movie] = []
    private(set) var totalPagesCount = 1
    
    private var moviesListDataLoadingTask: DataLoadingTask?
    
    var canLoadMoreMovies: Bool {
        currentPage < totalPagesCount
    }
    
    var currentListType: MovieListType = .popular {
        didSet {
            movieListTypeWasSelected(currentListType)
        }
    }
    
    public init(
        listMoviesProvider: ListMoviesProvider,
        lowResPosterProvider: LowResImageProvider
    ) {
        self.listMoviesProvider = listMoviesProvider
        self.lowResPosterProvider = lowResPosterProvider
    }
    
    func viewLoaded() {
        loadMovies()
    }
    
    func setup(cell: MovieListCell, at indexPath: IndexPath) {
        guard indexPath.row < movies.count else { return }
        let movie: Movie = movies[indexPath.row]
        let cellViewModel: MovieListCellViewModel = .init(movie: movie, lowResPosterProvider: lowResPosterProvider)
        cell.setup(with: cellViewModel)
        cellViewModel.view = cell
    }
    
    private func movieListTypeWasSelected(_ selectedMovieListType: MovieListType) {
        cleanMoviesData()
        loadMovies()
    }
    
    private func cleanMoviesData() {
        currentPage = 1
        movies = []
        totalPagesCount = 1
        moviesListDataLoadingTask?.cancel()
        moviesListDataLoadingTask = nil
    }
    
    func loadMovies() {
        switch currentListType {
        case .popular:
            moviesListDataLoadingTask = listMoviesProvider.fetchPopularMovies(page: currentPage) { [weak self] in self?.moviesWasLoaded($0)  }
        case .currentBroadcast:
            moviesListDataLoadingTask = listMoviesProvider.fetchCurrentlyBroadcastMovies(page: currentPage) { [weak self] in self?.moviesWasLoaded($0) }
        case .myFavorites:
            moviesListDataLoadingTask = listMoviesProvider.fetchFavoriteMovies(page: currentPage) { [weak self] in self?.moviesWasLoaded($0) }
        }
    }
    
    private func moviesWasLoaded(_ loadResult: Result<MovieList, MovieFetchingError>) {
        switch loadResult {
        case let .success(movieList):
            self.currentPage = movieList.currentPage ?? 1 + 1
            self.movies.append(contentsOf: movieList.movies)
            self.totalPagesCount = movieList.totalPagesCount
            view?.updateMovies()
        case let .failure(error):
            view?.displayError(error)
            break
        }
    }
}

protocol MoviesListView: AnyObject {
    func updateMovies()
    func displayError(_ error: MovieFetchingError)
}
