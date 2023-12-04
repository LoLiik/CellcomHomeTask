//
//  ErrorDisplayingRouter.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import CellcomHometaskModels

protocol ErrorDisplayingRouter: AnyObject {
    func displayError(_ error: MovieFetchingError)
}
