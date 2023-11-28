//
//  MovieList.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public struct MovieList: Decodable {
    let currentPage: Int?
    let movies: [Movie]
    let totalPagesCount: Int
    
    public init(currentPage: Int?, movies: [Movie], totalPagesCount: Int) {
        self.currentPage = currentPage
        self.movies = movies
        self.totalPagesCount = totalPagesCount
    }
}
