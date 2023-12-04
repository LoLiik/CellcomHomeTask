//
//  MovieList+Decodable.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

extension MovieList {
    public enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case movies = "results"
        case totalPagesCount = "total_pages"
    }
}
