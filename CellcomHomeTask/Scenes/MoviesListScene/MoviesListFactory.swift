//
//  MoviesListFactory.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit

final class MoviesListFactory {
    func build() -> UIViewController {
        let coordinator = MoviesListCoordinator()
        let networkWorker = NetworkWorker()
        let authWorker = AuthWorker(authProvider: networkWorker, userAuthPermissionRequestWorker: coordinator, sessionUpdater: networkWorker)
        let authNetworkDecorator = AuthenticationNetworkDecorator(decoratee: networkWorker, authWorker: authWorker)
        
        let accountDetailsProviderWorker = AccountDetailsProviderWorker(accountDetailsProvider: networkWorker, accountUpdater: networkWorker)
        let accountDetailsAndAuthNetworkDecorator = AccountDetailsProviderNetworkDecorator(decoratee: authNetworkDecorator, accountDetailsProvider: accountDetailsProviderWorker)
        
        let popularMoviesProvider = MoviesPageWorker { page, completion in
            networkWorker.fetchPopularMovies(page: page, completion: completion)
        }
        let currentBroadcastMoviesProvider = MoviesPageWorker { page, completion in
            networkWorker.fetchCurrentlyBroadcastMovies(page: page, completion: completion)
        }
        let myFavoriteMoviesPageWorker = MoviesPageWorker { page, completion in
            accountDetailsAndAuthNetworkDecorator.fetchFavoriteMovies(page: page, completion: completion)
        }
        
        let moviesProvider = MoviesProviderFacade(
            popularMoviesProvider: popularMoviesProvider,
            currentBroadcastMoviesProvider: currentBroadcastMoviesProvider,
            myFavoriteMoviesProvider: myFavoriteMoviesPageWorker
        )
        
        let movieDetailsFactory = MovieDetailsFactory()
        let errorAlertFactory = ErrorAlertFactory()
        let router = MoviesListRouter(
            coordinator: coordinator,
            movieDetailsFactory: movieDetailsFactory,
            errorAlertFactory: errorAlertFactory
        )
        
        let viewModel = MoviesListViewModel(
            moviesProvider: moviesProvider,
            lowResPosterProvider: networkWorker,
            router: router
        )
        
        let viewController = MoviesListViewController(viewModel: viewModel)
        viewModel.view = viewController
        coordinator.viewController = viewController
        return viewController
    }
}
