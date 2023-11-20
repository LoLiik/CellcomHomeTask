//
//  MoviesListBuilder.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit

final class MoviesListBuilder {
    func build() -> UIViewController {
        let coordinator = MoviesListCoordinator()
        let networkWorker = NetworkWorker()
        let authWorker = AuthWorker(authProvider: networkWorker, userAuthPermissionRequestWorker: coordinator, sessionUpdater: networkWorker)
        let authNetworkDecorator = AuthenticationNetworkDecorator(decoratee: networkWorker, authWorker: authWorker)
        
        let accountDetailsProviderWorker = AccountDetailsProviderWorker(accountDetailsProvider: networkWorker, accountUpdater: networkWorker)
        let accountDetailsAndAuthNetworkDecorator = AccountDetailsProviderNetworkDecorator(decoratee: authNetworkDecorator, accountDetailsProvider: accountDetailsProviderWorker)
                                                                        
        let viewModel = MoviesListViewModel(
            listMoviesProvider: accountDetailsAndAuthNetworkDecorator,
            lowResPosterProvider: networkWorker
        )
        
        let viewController = MoviesListViewController(viewModel: viewModel)
        viewModel.view = viewController
        coordinator.viewController = viewController
        return viewController
    }
}
