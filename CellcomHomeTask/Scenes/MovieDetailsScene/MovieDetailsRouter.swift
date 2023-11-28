//
//  MovieDetailsRouter.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

protocol MovieDetailsRouterProtocol: ErrorDisplayingRouter { }

final class MovieDetailsRouter {
    let coordinator: MovieDetailsCoordinator
    let errorAlertFactory: ErrorAlertFactoryProtocol
    
    init(
        coordinator: MovieDetailsCoordinator,
        errorAlertFactory: ErrorAlertFactoryProtocol
    ) {
        self.coordinator = coordinator
        self.errorAlertFactory = errorAlertFactory
    }
}

extension MovieDetailsRouter: MovieDetailsRouterProtocol {
    func displayError(_ error: MovieFetchingError) {
        let errorAlertController = errorAlertFactory.build(with: error)
        coordinator.show(errorAlertController)
    }
}

