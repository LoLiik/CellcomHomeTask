//
//  Session.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct Session: Decodable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}
