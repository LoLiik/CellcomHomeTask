//
//  File.swift
//  
//
//  Created by Евгений Кулиничев on 05.12.2023.
//

import CellcomHometaskModels
import CellcomHometaskProtocols
import Foundation

struct WrapperId {
    let page: Int
    var movies: [Movie]
}

public final class MoviesAllPagesProvider {
    private let networkWorker: MyFavoriteMoviePagesProvider
    
    public init(networkWorker: MyFavoriteMoviePagesProvider) {
        self.networkWorker = networkWorker
    }
    
    public func fetchAllMoviesWithoutOrder(completion: @escaping (Result<[Movie], MovieFetchingError>) -> Void) {
        initialFetch(completion: completion)
    }
    
    private func initialFetch(completion: @escaping (Result<[Movie], MovieFetchingError>) -> Void) {
        _ = networkWorker.fetchFavoriteMovies(page: 1) { [weak self] result in
            switch result {
            case let .success(movieList):
                self?.gettingAllOtherMoviesInParallel(firstMovies: movieList.movies, numberOfPages: movieList.totalPagesCount, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func gettingAllOtherMoviesInParallel(firstMovies: [Movie], numberOfPages: Int, completion: @escaping (Result<[Movie], MovieFetchingError>) -> Void) {
        var moviesByPages: [Int:[Movie]] = [1: firstMovies]
        var errors: [MovieFetchingError] = []
        
        let dispatchGroup = DispatchGroup()
        let numberOfPages = numberOfPages <= 500
                                ? numberOfPages
                                : 500
        for page in 2...numberOfPages {
            dispatchGroup.enter()
            _ = networkWorker.fetchFavoriteMovies(page: page) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case let .success(movieList):
                    moviesByPages[page] = movieList.movies
                case let .failure(error):
                    errors.append(error)
                }
            }
        }

        dispatchGroup.notify(
            queue: DispatchQueue.global(),
            work: DispatchWorkItem(
                block: { [weak self] in
                    self?.resultProcessing(moviesByPages: moviesByPages, errors: errors, completion: completion)
                }
            )
        )
    }
    
    private func resultProcessing(moviesByPages: [Int:[Movie]], errors: [MovieFetchingError], completion: (Result<[Movie], MovieFetchingError>) -> Void) {
        if !errors.isEmpty {
            for error in errors  {
                print("error: \(error)")
                completion(.failure(error))
            }
            print("ERRORS COUNT: \(errors.count)")
        } else {
            let sortedMovies = moviesByPages.sorted {
                $0.key < $1.key
            }
            let movies = sortedMovies.flatMap { $0.value }
            print("movie count: \(movies.count)")
            completion(.success(movies))
        }
    }
}
