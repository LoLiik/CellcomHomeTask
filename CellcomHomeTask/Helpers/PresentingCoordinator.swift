//
//  PresentingCoordinator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import UIKit

protocol PresentingCoordinator: AnyObject {
    var viewController: UIViewController? { get set }
    func show(_ viewController: UIViewController)
}

extension PresentingCoordinator {
    func show(_ viewControllerToPresent: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(viewControllerToPresent, animated: true)
        }
    }
}
