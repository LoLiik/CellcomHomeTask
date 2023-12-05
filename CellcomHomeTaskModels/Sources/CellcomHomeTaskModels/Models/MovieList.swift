//
//  MovieList.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct MovieList: Decodable, Equatable {
    public let currentPage: Int?
    public let movies: [Movie]?
    public let totalPagesCount: Int
    
    public init(currentPage: Int?, movies: [Movie], totalPagesCount: Int) {
        self.currentPage = currentPage
        self.movies = movies
        self.totalPagesCount = totalPagesCount
    }
}
