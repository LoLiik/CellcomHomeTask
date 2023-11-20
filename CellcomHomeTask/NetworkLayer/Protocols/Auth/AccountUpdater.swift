//
//  AccountUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol AccountUpdater: AnyObject {
    func updateAccountId(_ accountId: Int)
}
