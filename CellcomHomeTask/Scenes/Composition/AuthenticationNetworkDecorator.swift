//
//  AuthenticationNetworkDecorator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

/// Decorate type to call authentication if needed and repeat type request
final class AuthenticationNetworkDecorator<T> {
    private let decoratee: T
    private let authWorker: AuthWorkerProtocol
    
    init(decoratee: T, authWorker: AuthWorkerProtocol) {
        self.decoratee = decoratee
        self.authWorker = authWorker
    }
    
    private func decorate<G>(actionForDecoration: @escaping (@escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask?, originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return actionForDecoration { [weak self] result in
            if case let .failure(movieFetchingError) = result,
               movieFetchingError == .authDenied {
                self?.authenticate(
                    decoratedAction: {
                        _ = actionForDecoration(originalCompletion)
                    },
                    originalCompletion: originalCompletion
                )
                
            } else {
                originalCompletion(result)
            }
        }
    }
    
    @discardableResult
    private func authenticate<G>(decoratedAction: @escaping () -> Void, originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        authWorker.startAuthentication { authResult in
            switch authResult {
            case .success:
                decoratedAction()
            case let .failure(error):
                originalCompletion(.failure(error))
            }
        }
        return nil
    }
}

extension AuthenticationNetworkDecorator: FavoriteMovieUpdater where T == FavoriteMovieUpdater {
    func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                self?.decoratee.updateFavoriteMovie(movieId: movieId, isFavorite: isFavorite, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AuthenticationNetworkDecorator: MyFavoriteMoviesProvider where T: MyFavoriteMoviesProvider {
    func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.fetchFavoriteMovies(page: page, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AuthenticationNetworkDecorator: PopularMoviesProvider where T: PopularMoviesProvider {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchPopularMovies(page: page, completion: completion)
    }
}

extension AuthenticationNetworkDecorator: CurrentlyBroadcastMoviesProvider where T: CurrentlyBroadcastMoviesProvider {
    func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchCurrentlyBroadcastMovies(page: page, completion: completion)
    }
}
