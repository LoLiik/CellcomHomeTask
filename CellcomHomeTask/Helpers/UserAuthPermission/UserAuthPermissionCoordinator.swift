//
//  UserAuthPermissionCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import Foundation
import UIKit
import CellcomHometaskProtocols
import CellcomHometaskModels
import CellcomHometaskNetwork

protocol UserAuthPermissionCoordinator: UserAuthPermissionRequestWorkerProtocol, UserAuthPermissionRequestDelegate {
    var viewController: UIViewController? { get }
}

extension UserAuthPermissionCoordinator {
    func requestUserAuthPermission(url: URL, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let authPermissionWebViewController = UserAuthPermissionWebViewController(delegate: self)
            authPermissionWebViewController.requestUserAuthPermission(url: url, completion: completion)
            self.viewController?.present(authPermissionWebViewController, animated: true)
        }
    }
    
    func didRequestUserAuthWithSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.dismiss(animated: true)
        }
    }
}
