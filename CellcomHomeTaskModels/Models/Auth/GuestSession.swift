//
//  GuestSession.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

public struct GuestSession: Decodable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

extension GuestSession {
    enum CodingKeys: String, CodingKey {
        case id = "guest_session_id"
    }
}
