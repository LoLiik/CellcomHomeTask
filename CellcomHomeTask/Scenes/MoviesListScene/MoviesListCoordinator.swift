//
//  PopularMoviesListCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit
import Foundation

protocol MoviesListCoordinatorProtocol: PresentingCoordinator { }

final class MoviesListCoordinator {
    weak var viewController: UIViewController?
}

extension MoviesListCoordinator: MoviesListCoordinatorProtocol { }

extension MoviesListCoordinator: UserAuthPermissionCoordinator { }
