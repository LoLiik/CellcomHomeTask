//
//  MoviesListRouter.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 27.11.2023.
//

import UIKit
import CellcomHomeTaskModels
import CellcomHometaskProtocols

protocol MoviesListRouterProtocol: ErrorDisplayingRouter {
    func openMovieDetails(_ movie: Movie, completion: @escaping (Bool) -> Void )
}

class MoviesListRouter {
    let coordinator: MoviesListCoordinatorProtocol
    let movieDetailsFactory: MovieDetailsFactoryProtocol
    let errorAlertFactory: ErrorAlertFactory
    
    init(
        coordinator: MoviesListCoordinator,
        movieDetailsFactory: MovieDetailsFactoryProtocol,
        errorAlertFactory: ErrorAlertFactory
    ) {
        self.coordinator = coordinator
        self.movieDetailsFactory = movieDetailsFactory
        self.errorAlertFactory = errorAlertFactory
    }
}

extension MoviesListRouter: MoviesListRouterProtocol {
    func openMovieDetails(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        let movieDetailsViewController = movieDetailsFactory.buildMovieDetails(with: movie, completion: completion)
        coordinator.show(movieDetailsViewController)
    }
    
    func displayError(_ error: MovieFetchingError) {
        let alertViewController = errorAlertFactory.build(with: error)
        coordinator.show(alertViewController)
    }
}
