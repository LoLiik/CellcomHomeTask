//
//  MovieDetailsCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import UIKit

protocol MoviesDetailsCoordinatorProtocol: PresentingCoordinator {
    func dissmiss()
}

final class MovieDetailsCoordinator {
    weak var viewController: UIViewController?
}

extension MovieDetailsCoordinator: MoviesDetailsCoordinatorProtocol {
    func dissmiss() {
        viewController?.dismiss(animated: true)
    }
}

extension MovieDetailsCoordinator: UserAuthPermissionCoordinator { }
