//
//  MoviesListRouter.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 27.11.2023.
//

protocol MoviesListRouterProtocol: AnyObject {
    func openMovieDetails(_ movie: Movie, completion: @escaping (Bool) -> Void )
}

class MoviesListRouter {
    let coordinator: MoviesListCoordinatorProtocol
    let movieDetailsFactory: MovieDetailsFactoryProtocol
    
    init(coordinator: MoviesListCoordinator, movieDetailsFactory: MovieDetailsFactoryProtocol) {
        self.coordinator = coordinator
        self.movieDetailsFactory = movieDetailsFactory
    }
}

extension MoviesListRouter: MoviesListRouterProtocol {
    func openMovieDetails(_ movie: Movie, completion: @escaping (Bool) -> Void) {
        let movieDetailsViewController = movieDetailsFactory.buildMovieDetails(with: movie, completion: completion)
        coordinator.show(movieDetailsViewController)
    }
}
