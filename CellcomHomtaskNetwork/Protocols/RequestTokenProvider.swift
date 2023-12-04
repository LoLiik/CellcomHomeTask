//
//  RequestTokenProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

protocol RequestTokenProvider: AnyObject {
    func generateRequestToken(completion: @escaping (Result<RequestToken, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
}
