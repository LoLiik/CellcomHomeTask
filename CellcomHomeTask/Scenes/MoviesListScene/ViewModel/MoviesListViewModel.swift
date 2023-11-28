//
//  MoviesListViewModel.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation
import CellcomHometaskProtocols
import CellcomHomeTaskModels

enum MovieListType {
    case popular
    case myFavorites
    case currentBroadcast
}

protocol MoviesListViewModelProtocol: AnyObject {
    var movies: [Movie] { get }
    var currentListType: MovieListType { get set }
    var haveMoreMoviesToLoad: Bool { get }
    func loadMovies()
    func setup(cell: MovieListCell, at: IndexPath)
    func showMovieDetails(_ movie: Movie)
}

final class MoviesListViewModel: MoviesListViewModelProtocol {
    weak var view: MoviesListView?
    
    private let lowResPosterProvider: LowResImageProvider
    private let moviesProvider: MoviesProvider & MovieListTypeSelectionDelegate
    private let router: MoviesListRouterProtocol
    private var shouldDisplayEmptyStateWhileChangingType = false
    
    private var moviesListDataLoadingTask: DataLoadingTask?
    private var shouldReloadFavoriteMovies: Bool = false {
        didSet {
            if shouldReloadFavoriteMovies, currentListType == .myFavorites {
                loadMovies()
            }
        }
    }
    
    var haveMoreMoviesToLoad: Bool {
        moviesProvider.haveMorePages
    }
    
    var movies: [Movie] {
        guard !shouldDisplayEmptyStateWhileChangingType else { return [] }
        return moviesProvider.movies
    }
    
    var currentListType: MovieListType = .popular {
        didSet {
            view?.updateMovies()
            let shouldResetData = currentListType == .myFavorites && shouldReloadFavoriteMovies
            moviesProvider.movieListTypeWasSelected(currentListType, shouldResetData: shouldResetData)
            updateViewAfterNewMovieTypeSelection()
        }
    }
    
    public init(
        moviesProvider: MoviesProvider & MovieListTypeSelectionDelegate,
        lowResPosterProvider: LowResImageProvider,
        router: MoviesListRouterProtocol
    ) {
        self.moviesProvider = moviesProvider
        self.lowResPosterProvider = lowResPosterProvider
        self.router = router
    }
    
    func setup(cell: MovieListCell, at indexPath: IndexPath) {
        guard indexPath.row < movies.count else { return }
        let movie: Movie = movies[indexPath.row]
        let cellViewModel: MovieListCellViewModel = .init(movie: movie, lowResPosterProvider: lowResPosterProvider)
        cell.setup(with: cellViewModel)
        cellViewModel.view = cell
    }
    
    func loadMovies() {
        shouldDisplayEmptyStateWhileChangingType = true
        moviesListDataLoadingTask = moviesProvider.fetchMovies() { [weak self] in
            guard let self = self else { return }
            if self.currentListType == .myFavorites {
                self.shouldReloadFavoriteMovies = false
            }
            self.shouldDisplayEmptyStateWhileChangingType = false
            self.moviesWasLoaded($0)
        }
    }
    
    func showMovieDetails(_ movie: Movie) {
        router.openMovieDetails(movie) { [weak self] favoriteWasChanged in
            guard let self = self, favoriteWasChanged else { return }
            self.shouldReloadFavoriteMovies = favoriteWasChanged
        }
    }
    
    private func updateViewAfterNewMovieTypeSelection() {
        let needToReloadFavoriteMovies = shouldReloadFavoriteMovies && currentListType == .myFavorites
        if movies.count == 0 || needToReloadFavoriteMovies {
            loadMovies()
        } else {
            view?.updateMovies()
        }
    }
    
    private func moviesWasLoaded(_ loadResult: Result<Void, MovieFetchingError>) {
        switch loadResult {
        case .success:
            view?.updateMovies()
        case let .failure(error):
            router.displayError(error)
        }
    }
}

protocol MoviesListView: AnyObject {
    func updateMovies()
}
