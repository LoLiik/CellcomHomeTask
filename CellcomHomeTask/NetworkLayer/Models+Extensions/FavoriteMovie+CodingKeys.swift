//
//  FavoriteMovie+CodingKeys.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

extension FavoriteMovie {
    enum CodingKeys: String, CodingKey {
        case id = "media_id"
        case isFavorite = "favorite"
        case mediaType = "media_type"
    }
}
