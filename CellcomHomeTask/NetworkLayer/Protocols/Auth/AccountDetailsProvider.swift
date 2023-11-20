//
//  AccountDetailsProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol AccountDetailsProvider: AnyObject {
    func fetchAccountDetails(completion: @escaping (Result<Account, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
