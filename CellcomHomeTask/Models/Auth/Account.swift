//
//  Account.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct Account: Decodable {
    let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
