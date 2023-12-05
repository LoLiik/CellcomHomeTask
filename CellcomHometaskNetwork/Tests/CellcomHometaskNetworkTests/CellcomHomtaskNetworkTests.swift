//
//  AuthenticationNetworkDecoratorTests.swift
//  CellcomHometaskNetworkTests
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import XCTest
import CellcomHometaskProtocols
import CellcomHometaskModels
@testable import CellcomHometaskNetwork

final class AuthenticationNetworkDecoratorTests: XCTestCase {
    
    // MARK: - PopularMoviePagesProvider
    func test_fetchPopularMovies_resultWithSuccess_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: PopularMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchPopularMovies(page: 1) { result in
            receivedResult = result
        }
        
        let expectedResult: Result<MovieList, MovieFetchingError> = .success(anyMovieList)
        decoratee.providePopularMoviePagesCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call succeded")
        XCTAssertEqual(decoratee.providePopularMoviePagesCalls.count, 1, "Movie fetching should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_fetchPopularMovies_resultWithFailure_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: PopularMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchPopularMovies(page: 1) { result in
            receivedResult = result
        }
        
        let expectedResult: Result<MovieList, MovieFetchingError> = .failure(.unknown)
        decoratee.providePopularMoviePagesCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call failed with any error other then authDenied")
        XCTAssertEqual(decoratee.providePopularMoviePagesCalls.count, 1, "Movie fetching should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    // MARK: - PopularMoviePagesProvider
    func test_fetchCurrentlyBroadcastMovies_resultsWithSuccess_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: CurrentlyBroadcastPagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchCurrentlyBroadcastMovies(page: 1) { result in
            receivedResult = result
        }
        
        let expectedResult: Result<MovieList, MovieFetchingError> = .success(anyMovieList)
        decoratee.provideCurrentlyBroadcastMoviePagesCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call succeded")
        XCTAssertEqual(decoratee.provideCurrentlyBroadcastMoviePagesCalls.count, 1, "Movie fetching should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_fetchCurrentlyBroadcastMovies_resultsWithFailure_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: CurrentlyBroadcastPagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchCurrentlyBroadcastMovies(page: 1) { result in
            receivedResult = result
        }
        
        let expectedResult: Result<MovieList, MovieFetchingError> = .failure(.unknown)
        decoratee.provideCurrentlyBroadcastMoviePagesCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call failed with any error other then authDenied")
        XCTAssertEqual(decoratee.provideCurrentlyBroadcastMoviePagesCalls.count, 1, "Movie fetching should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    // MARK: - MyFavoriteMoviePagesProvider
    func test_myFavoriteMoviePagesProviderDecoration_resultsWithSuccess_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: MyFavoriteMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchFavoriteMovies(page: 1) { result in
            receivedResult = result
        }
        
        let expectedResult: Result<MovieList, MovieFetchingError> = .success(anyMovieList)
        decoratee.provideMyFavoriteMoviePagesCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call succeded")
        XCTAssertEqual(decoratee.provideMyFavoriteMoviePagesCalls.count, 1, "Movie fetching should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_myFavoriteMoviePagesProviderDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authSuccess_repeatMovieFetch_resultWithSuccess() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: MyFavoriteMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchFavoriteMovies(page: 1) { receivedResult = $0 }
        
        decoratee.provideMyFavoriteMoviePagesCalls[0](.failure(.authDenied))
        authWorker.startAuthenticationCalls[0](.success(()))
        let expectedResult: Result<MovieList, MovieFetchingError> = .success(anyMovieList)
        decoratee.provideMyFavoriteMoviePagesCalls[1](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.provideMyFavoriteMoviePagesCalls.count, 2, "Movie fetching should be called twice - initially and after authorization")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_myFavoriteMoviePagesProviderDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authSuccess_repeatMovieFetch_resultWithFailure() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: MyFavoriteMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchFavoriteMovies(page: 1) { receivedResult = $0 }
        
        decoratee.provideMyFavoriteMoviePagesCalls[0](.failure(.authDenied))
        authWorker.startAuthenticationCalls[0](.success(()))
        let expectedResult: Result<MovieList, MovieFetchingError> = .failure(.unknown)
        decoratee.provideMyFavoriteMoviePagesCalls[1](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.provideMyFavoriteMoviePagesCalls.count, 2, "Movie fetching should be called twice - initially and repeat after authorization")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_myFavoriteMoviePagesProviderDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authFailure_callDecorateeWithAuthDenied() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: MyFavoriteMoviePagesProviderMock())
        
        var receivedResult: Result<MovieList, MovieFetchingError>?
        sut.fetchFavoriteMovies(page: 1) { result in
            receivedResult = result
        }
        
        let authDeniedResult: Result<MovieList, MovieFetchingError> = .failure(.authDenied)
        decoratee.provideMyFavoriteMoviePagesCalls[0](authDeniedResult)
        
        authWorker.startAuthenticationCalls[0](.failure(.unknown))
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.provideMyFavoriteMoviePagesCalls.count, 1, "Movie fetching should be called once - no repeat if authorization failed")
        XCTAssertEqual(receivedResult, .failure(.authDenied))
    }
    
    // MARK: - FavoriteMovieUpdater
    func test_favoriteMovieUpdaterDecoration_resultsWithSuccess_proxiesCallToDecoratee() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: FavoriteMovieUpdaterMock())
        
        var receivedResult: Result<TMDBResponse, MovieFetchingError>?
        sut.updateFavoriteMovie(movieId: 1, isFavorite: true) { receivedResult = $0 }
        
        let expectedResult: Result<TMDBResponse, MovieFetchingError> = .success(anyTMDBResponse)
        decoratee.updateFavoriteMovieCalls[0](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 0, "Authorizaion should not be called if initial call succeded")
        XCTAssertEqual(decoratee.updateFavoriteMovieCalls.count, 1, "Movie updating should be called once")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_favoriteMovieUpdaterDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authSuccess_repeatMovieFetch_resultWithSuccess() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: FavoriteMovieUpdaterMock())
        
        var receivedResult: Result<TMDBResponse, MovieFetchingError>?
        sut.updateFavoriteMovie(movieId: 1, isFavorite: true) { receivedResult = $0 }
        
        decoratee.updateFavoriteMovieCalls[0](.failure(.authDenied))
        authWorker.startAuthenticationCalls[0](.success(()))
        let expectedResult: Result<TMDBResponse, MovieFetchingError> = .success(anyTMDBResponse)
        decoratee.updateFavoriteMovieCalls[1](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.updateFavoriteMovieCalls.count, 2, "Movie updating should be called twice - initially and repeat after authorization")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_favoriteMovieUpdaterDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authSuccess_repeatMovieFetch_resultWithFailure() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: FavoriteMovieUpdaterMock())
        
        var receivedResult: Result<TMDBResponse, MovieFetchingError>?
        sut.updateFavoriteMovie(movieId: 1, isFavorite: true) { receivedResult = $0 }
        
        decoratee.updateFavoriteMovieCalls[0](.failure(.authDenied))
        authWorker.startAuthenticationCalls[0](.success(()))
        let expectedResult: Result<TMDBResponse, MovieFetchingError> = .failure(.unknown)
        decoratee.updateFavoriteMovieCalls[1](expectedResult)
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.updateFavoriteMovieCalls.count, 2, "Movie updating should be called twice - initially and repeat after authorization")
        XCTAssertEqual(receivedResult, expectedResult)
    }
    
    func test_favoriteMovieUpdaterDecoration_resultsWithAuthDeniedFailure_callAuthWorker_authFailure_callDecorateeWithAuthDenied() {
        let (sut, decoratee, authWorker) = makeSUT(decoratee: FavoriteMovieUpdaterMock())
        
        var receivedResult: Result<TMDBResponse, MovieFetchingError>?
        sut.updateFavoriteMovie(movieId: 1, isFavorite: true) { receivedResult = $0 }
        
        decoratee.updateFavoriteMovieCalls[0](.failure(.authDenied))
        
        authWorker.startAuthenticationCalls[0](.failure(.unknown))
        
        XCTAssertEqual(authWorker.startAuthenticationCalls.count, 1, "Authorizaion should be called once when have authDenied error")
        XCTAssertEqual(decoratee.updateFavoriteMovieCalls.count, 1, "Movie updating should be called once - no repeat if authorization failed")
        XCTAssertEqual(receivedResult, .failure(.authDenied))
    }
    
    private func makeSUT<T>(decoratee: T, file: StaticString = #filePath, line: UInt = #line) -> (sut: AuthenticationNetworkDecorator<T>, decoratee: T, authWorker: AuthWorkerProtocolMock) {
        let authWorker = AuthWorkerProtocolMock()
        let sut = AuthenticationNetworkDecorator(
            decoratee: decoratee,
            authWorker: authWorker
        )
        checkForMemoryLeak(authWorker, file: file, line: line)
        checkForMemoryLeak(decoratee as AnyObject, file: file, line: line)
        checkForMemoryLeak(sut, file: file, line: line)
        
        return (sut: sut, decoratee: decoratee, authWorker: authWorker)
    }
    
    private func checkForMemoryLeak(_ object: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private var anyMovieList: MovieList {
        .init(currentPage: nil, movies: [anyMovie, anyMovie], totalPagesCount: 1)
    }
    
    private var anyMovie: Movie {
        .init(id: 1, title: "some title", voteAverage: 0.0, releaseDateString: "", posterPath: "", overview: "")
    }
    
    private var anyFetchingErrorExceptAuthError: MovieFetchingError {
        .unknown
    }
    
    private var anyTMDBResponse: TMDBResponse {
        .init(success: nil, failure: nil, statusCode: 1, statusMessage: "some error message")
    }
}

class PopularMoviePagesProviderMock: PopularMoviePagesProvider {
    var providePopularMoviePagesCalls: [(Result<MovieList, MovieFetchingError>) -> Void] = []
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        providePopularMoviePagesCalls.append(completion)
        return nil
    }
}

class CurrentlyBroadcastPagesProviderMock: CurrentlyBroadcastMoviePagesProvider {
    var provideCurrentlyBroadcastMoviePagesCalls: [(Result<MovieList, MovieFetchingError>) -> Void] = []
    func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        provideCurrentlyBroadcastMoviePagesCalls.append(completion)
        return nil
    }
}

class MyFavoriteMoviePagesProviderMock: MyFavoriteMoviePagesProvider {
    var provideMyFavoriteMoviePagesCalls: [(Result<MovieList, MovieFetchingError>) -> Void] = []
    func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        provideMyFavoriteMoviePagesCalls.append(completion)
        return nil
    }
}

class AuthWorkerProtocolMock: AuthWorkerProtocol {
    var startAuthenticationCalls: [(Result<Void, MovieFetchingError>) -> Void] = []
    func startAuthentication(updatableTask: DataLoadingTaskUpdatable, completion: @escaping (Result<Void, MovieFetchingError>) -> Void) {
        startAuthenticationCalls.append(completion)
    }
}

class FavoriteMovieUpdaterMock: FavoriteMovieUpdater {
    var updateFavoriteMovieCalls: [(Result<TMDBResponse, MovieFetchingError>) -> Void] = []
    func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        updateFavoriteMovieCalls.append(completion)
        return nil
    }
}
