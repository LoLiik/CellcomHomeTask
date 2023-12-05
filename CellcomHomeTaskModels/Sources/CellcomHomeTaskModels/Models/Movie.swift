//
//  Movie.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

public struct Movie: Decodable, Equatable {
    public let id: Int
    public let title: String
    public let voteAverage: Float
    public let releaseDateString: String
    public let posterPath: String?
    public let overview: String
    
    public var releaseDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let releaseDate = formatter.date(from: releaseDateString)
        return releaseDate
    }
    
    public init(id: Int, title: String, voteAverage: Float, releaseDateString: String, posterPath: String, overview: String) {
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.releaseDateString = releaseDateString
        self.posterPath = posterPath
        self.overview = overview
    }
}
