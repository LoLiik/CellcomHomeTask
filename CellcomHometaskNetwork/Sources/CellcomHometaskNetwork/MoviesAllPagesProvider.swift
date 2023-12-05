//
//  File.swift
//  
//
//  Created by Евгений Кулиничев on 05.12.2023.
//

import CellcomHometaskModels
import CellcomHometaskProtocols
import Foundation

public final class MoviesAllPagesProvider {
    public typealias FetchMoviePageHandler = (Int, @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
    
    private let fetchMoviePage: FetchMoviePageHandler
    
    public init(fetchMoviePage: @escaping FetchMoviePageHandler) {
        self.fetchMoviePage = fetchMoviePage
    }
    
    public func fetchAllMoviesWithoutOrder(completion: @escaping (Result<[Movie], MovieFetchingError>) -> Void) {
        initialFetch(completion: completion)
    }
    
    private func initialFetch(completion: @escaping (Result<[Movie], MovieFetchingError>) -> Void) {
        _ = fetchMoviePage(1) { [weak self] result in
            switch result {
            case let .success(movieList):
                let firstMovies = movieList.movies ?? []
                if movieList.totalPagesCount > 1 {
                    self?.gettingAllOtherMoviesInParallel(firstMovies: firstMovies, numberOfPages: movieList.totalPagesCount, completion: completion)
                } else {
                    completion(.success(firstMovies))
                }
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
            _ = fetchMoviePage(page) { result in
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
        if !moviesByPages.isEmpty {
            let sortedMovies = moviesByPages.sorted {
                $0.key < $1.key
            }
            let movies = sortedMovies.flatMap { $0.value }
            completion(.success(movies))
        } else if !errors.isEmpty {
            completion(.failure(errors[0]))
        }
    }
}
