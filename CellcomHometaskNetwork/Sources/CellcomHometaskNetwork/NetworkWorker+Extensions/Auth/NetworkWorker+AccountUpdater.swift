//
//  NetworkWorker+AccountUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskProtocols

extension NetworkWorker: AccountUpdater {
    public func updateAccountId(_ accountId: Int) {
        Config.accountId = accountId
    }
}

