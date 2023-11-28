//
//  MovieDetailsFactory.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 27.11.2023.
//

import Foundation
import UIKit

protocol MovieDetailsFactoryProtocol: AnyObject {
    func buildMovieDetails(with movie: Movie, completion: @escaping (Bool) -> Void) -> UIViewController
}

class MovieDetailsFactory: MovieDetailsFactoryProtocol {
    func buildMovieDetails(with movie: Movie, completion: @escaping (Bool) -> Void) -> UIViewController {
        let coordinator = MovieDetailsCoordinator()
        let networkWorker = NetworkWorker()
        let authWorker = AuthWorker(authProvider: networkWorker, userAuthPermissionRequestWorker: coordinator, sessionUpdater: networkWorker)
        let authNetworkDecorator = AuthenticationNetworkDecorator(decoratee: networkWorker, authWorker: authWorker)
        
        let accountDetailsProviderWorker = AccountDetailsProviderWorker(accountDetailsProvider: networkWorker, accountUpdater: networkWorker)
        let accountDetailsAndAuthNetworkDecorator = AccountDetailsProviderNetworkDecorator(decoratee: authNetworkDecorator, accountDetailsProvider: accountDetailsProviderWorker)
        
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieUpdater: accountDetailsAndAuthNetworkDecorator,
            highResImageProvider: networkWorker,
            updateCompletion: completion
        )
        
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .red
        coordinator.viewController = viewController
        
        return viewController
    }
}
