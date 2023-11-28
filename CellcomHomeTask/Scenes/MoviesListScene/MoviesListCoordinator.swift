//
//  PopularMoviesListCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit
import Foundation

protocol MoviesListCoordinatorProtocol: AnyObject {
    func show(_ presentedViewContoller: UIViewController)
}

final class MoviesListCoordinator {
    weak var viewController: UIViewController?
}

extension MoviesListCoordinator: MoviesListCoordinatorProtocol {
    func show(_ viewControllerToShow: UIViewController) {
        viewController?.present(viewControllerToShow, animated: true)
    }
}

extension MoviesListCoordinator: UserAuthPermissionCoordinator { }
