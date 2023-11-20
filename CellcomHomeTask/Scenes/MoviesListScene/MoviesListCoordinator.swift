//
//  PopularMoviesListCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit
import Foundation

final class MoviesListCoordinator {
    weak var viewController: UIViewController?
}

extension MoviesListCoordinator: UserAuthPermissionRequestWorkerProtocol {
    func requestUserAuthPermission(url: URL, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let authPermissionWebViewController = UserAuthPermissionWebViewController(delegate: self)
            self.viewController?.present(authPermissionWebViewController, animated: true)
            authPermissionWebViewController.requestUserAuthPermission(url: url, completion: completion)
        }
    }
}

extension MoviesListCoordinator: UserAuthPermissionRequestDelegate {
    func didRequestUserAuthWithSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}

