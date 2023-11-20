//
//  RequestToken.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct RequestToken: Codable {
    let token: String
    
    public init(token: String) {
        self.token = token
    }
}
