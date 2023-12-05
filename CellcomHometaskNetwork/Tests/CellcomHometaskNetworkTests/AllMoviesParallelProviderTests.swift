//
//  AllMoviesParallelProviderTests.swift
//  
//
//  Created by Евгений Кулиничев on 05.12.2023.
//

import XCTest
import CellcomHometaskModels
import CellcomHometaskProtocols
import CellcomHometaskNetwork

final class AllMoviesParallelProviderTests: XCTestCase {

    func test_allMoviesParallelProvider_fetching() {
        let (sut, provider) = makeSUT()
        var receivedResult: Result<[Movie], MovieFetchingError>?
        let expectation = expectation(description: "All movies are fetched or fetching error received")
        sut.fetchAllMoviesWithoutOrder { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
        if case let .success(movies) = receivedResult {
            XCTAssertEqual(movies, provider.movies, "Recevied movies different then provided")
        } else {
            XCTFail("Received failure")
        }
    }
    
    private func makeSUT() -> (sut: MoviesAllPagesProvider, provider: MoviesPagesProviderMock) {
        let moviesPagesProviderMock = MoviesPagesProviderMock()
        let sut = MoviesAllPagesProvider(fetchMoviePage: { page, completion in
            moviesPagesProviderMock.fetchMovies(page: page, completion: completion)
        })
        
        return (sut, moviesPagesProviderMock)
    }
}

final class MoviesPagesProviderMock {
    enum Constants {
        static let moviesPerPageCount = 20
        static let numberOfMovies = 10000
    }
    
    lazy var movies = {
        var movies: [Movie] = []
        (0..<Constants.numberOfMovies).forEach { _ in
            movies.append(anyMovie)
        }
        return movies
    }()
   
    func fetchMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        let lowerBound = page * Constants.moviesPerPageCount - Constants.moviesPerPageCount
        let upperBound = page * Constants.moviesPerPageCount - 1
        let currentMoviesForPage = movies[lowerBound...upperBound]
        
        let movieList: MovieList = .init(
            currentPage: page,
            movies: Array(currentMoviesForPage),
            totalPagesCount: movies.count / Constants.moviesPerPageCount
        )
        completion(.success(movieList))
        return nil
    }
}

var anyMovie: Movie {
    .init(id: Int.random(in: 1...1000000), title: "Some title", voteAverage: Float.random(in: 0.0...10.0), releaseDateString: "", posterPath: "", overview: "")
}
