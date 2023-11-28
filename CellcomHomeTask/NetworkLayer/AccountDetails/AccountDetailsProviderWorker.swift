//
//  AccountDetailsProviderWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

/// Updates account details before proxiing
final class AccountDetailsProviderWorker {
    let accountDetailsProvider: AccountDetailsProvider
    let accountUpdater: AccountUpdater
    
    init(accountDetailsProvider: AccountDetailsProvider, accountUpdater: AccountUpdater) {
        self.accountDetailsProvider = accountDetailsProvider
        self.accountUpdater = accountUpdater
    }
}

extension AccountDetailsProviderWorker: AccountDetailsProvider {
    func fetchAccountDetails(completion: @escaping (Result<Account, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return accountDetailsProvider.fetchAccountDetails { [weak self] accountInfoResult in
            if case let .success(account) = accountInfoResult {
                self?.accountUpdater.updateAccountId(account.id)
            }
            completion(accountInfoResult)
        }
    }
}

