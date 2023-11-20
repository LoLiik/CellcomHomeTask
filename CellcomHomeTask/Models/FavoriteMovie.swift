//
//  FavoriteMovie.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct FavoriteMovie: Encodable {
    let id: Int
    let isFavorite: Bool
    let mediaType: String
    
    init(id: Int, isFavorite: Bool, mediaType: String = "movie") {
        self.id = id
        self.isFavorite = isFavorite
        self.mediaType = mediaType
    }
}
