//
//  ErrorAlertFactory.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import UIKit
import CellcomHomeTaskModels

protocol ErrorAlertFactoryProtocol: AnyObject {
    func build(with error: MovieFetchingError) -> UIAlertController
}

class ErrorAlertFactory {
    struct AlertContext {
        let title: String?
        let message: String?
        let preferredStyle: UIAlertController.Style
    }
    
    private func createContext(for error: MovieFetchingError) -> AlertContext {
        let title = createTitle(for: error)
        let message = createMessage(for: error)
        let preferredStyle = createPreferredStyle(for: error)
        return .init(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
    }
    
    private func createTitle(for error: MovieFetchingError) -> String? {
        switch error {
        case .authDenied:
            return "Authorization denied"
        case .noData:
            return "Received no movies"
        case .timeout:
            return "Connection error"
        default:
            return "Request Error"
        }
    }
    
    private func createMessage(for error: MovieFetchingError) -> String? {
        switch error {
        case .authDenied:
            return "Try to authenticate again (via favorite movies or adding movie to favorite"
        case .noData:
            return "Server delivered no movies for this category"
        case .timeout:
            return "Try again later"
        default:
            return "Send us description of the error"
        }
    }
    
    private func createPreferredStyle(for error: MovieFetchingError) -> UIAlertController.Style {
        return .alert
    }
}

extension ErrorAlertFactory: ErrorAlertFactoryProtocol {
    func build(with error: MovieFetchingError) -> UIAlertController {
        let alertContext = createContext(for: error)
        let alertController = UIAlertController(title: alertContext.title, message: alertContext.message, preferredStyle: alertContext.preferredStyle)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            DispatchQueue.main.async {
                alertController?.dismiss(animated: true)
            }
        }
        alertController.addAction(okAction)
        return alertController
    }
}
