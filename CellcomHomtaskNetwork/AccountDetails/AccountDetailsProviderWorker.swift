//
//  AccountDetailsProviderWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskProtocols
import CellcomHomeTaskModels

/// Updates account details before proxiing
public final class AccountDetailsProviderWorker {
    let accountDetailsProvider: AccountDetailsProvider
    let accountUpdater: AccountUpdater
    
    public init(accountDetailsProvider: AccountDetailsProvider, accountUpdater: AccountUpdater) {
        self.accountDetailsProvider = accountDetailsProvider
        self.accountUpdater = accountUpdater
    }
}

extension AccountDetailsProviderWorker: AccountDetailsProvider {
    public func fetchAccountDetails(completion: @escaping (Result<Account, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return accountDetailsProvider.fetchAccountDetails { [weak self] accountInfoResult in
            if case let .success(account) = accountInfoResult {
                self?.accountUpdater.updateAccountId(account.id)
            }
            completion(accountInfoResult)
        }
    }
}

