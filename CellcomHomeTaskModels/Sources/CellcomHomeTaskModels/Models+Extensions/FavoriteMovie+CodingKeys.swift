//
//  FavoriteMovie+CodingKeys.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

extension FavoriteMovie {
    public enum CodingKeys: String, CodingKey {
        case id = "media_id"
        case isFavorite = "favorite"
        case mediaType = "media_type"
    }
}
