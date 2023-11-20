//
//  Movie.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

public struct Movie: Decodable {
    let id: Int
    let title: String
    let voteAverage: Float
    let releaseDate: Date
    let posterPath: String?
    let overview: String
    
    public init(id: Int, title: String, voteAverage: Float, releaseDate: Date, posterPath: String, overview: String) {
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.overview = overview
    }
}
