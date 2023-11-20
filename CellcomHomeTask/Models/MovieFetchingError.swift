//
//  MovieFetchingError.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public enum MovieFetchingError: Error, Equatable {
    case timeout
    case wrongRequest
    case noData
    case authDenied
    case decodingError
    case noAccountId
    case unknown
}
