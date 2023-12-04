//
//  AccountDetailsProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

public protocol AccountDetailsProvider: AnyObject {
    func fetchAccountDetails(completion: @escaping (Result<Account, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
}
