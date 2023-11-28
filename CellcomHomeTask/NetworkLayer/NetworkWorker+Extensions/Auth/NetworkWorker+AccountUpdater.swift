//
//  NetworkWorker+AccountUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

extension NetworkWorker: AccountUpdater {
    public func updateAccountId(_ accountId: Int) {
        Config.accountId = accountId
    }
}

