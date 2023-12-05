//
//  Movie+Decodable.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

extension Movie {
    public enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case releaseDateString = "release_date"
        case posterPath = "poster_path"
        case overview
    }
}
