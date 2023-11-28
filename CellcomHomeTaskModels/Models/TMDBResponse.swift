//
//  TMDBError.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

public struct TMDBResponse: Decodable, Equatable {
    public let success: Bool?
    public let failure: Bool?
    public let statusCode: Int
    public let statusMessage: String
}

extension TMDBResponse {
    enum CodingKeys: String, CodingKey {
        case success, failure
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
