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
    
    /// Separate original action (request) from original completion
    ///  and wrapping original action with authentication
    /// - Parameters:
    ///   - actionForDecoration: closure that receives closure of completion
    ///   - originalCompletion: closure handling result of original action
    /// - Returns: task object for cancelation at any moment
    private func decorate<G>(
        actionForDecoration: @escaping (@escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask?,
        originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void)
    -> DataLoadingTask? {
        // 1. Creating new task wrapper to be able to cancel current task at any moment
        let updatableTask = UpdatableCancebleTaskProxy()
        // 2. running original action with wrapped completion and saving closure to current task
        let currentTask = actionForDecoration { [weak self] result in
            // 2.1 if we have authDenied error in result of original action,
            // we are trying to authenticate first and then execute original action
            if case let .failure(movieFetchingError) = result,
               movieFetchingError == .authDenied {
                self?.authenticate(
                    decoratedAction: {
                        updatableTask.currentTask = actionForDecoration(originalCompletion)
                    },
                    originalCompletion: originalCompletion,
                    updatableTask: updatableTask
                )
            // 2.2 otherwise we are executing original completion
            } else {
                originalCompletion(result)
                updatableTask.currentTask = nil
            }
        }
        
        // 3. Updating our task wrapper with task of executing original action with wrapped completion
        updatableTask.currentTask = currentTask
        return updatableTask
    }
    
    /// Calling AuthWorker to authenticate
    /// - Parameters:
    ///   - decoratedAction: closure to execute in success case (usually it is original action with original completions)
    ///   - originalCompletion: closure handling result of original action
    ///   - updatableTask: task wrapper passing to auth worker (to update current task for cancelation at any moment)
    private func authenticate<G>(
        decoratedAction: @escaping () -> Void,
        originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void,
        updatableTask: DataLoadingTaskUpdatable
    ) {
       authWorker.startAuthentication(updatableTask: updatableTask) { authResult in
            switch authResult {
            case .success:
                decoratedAction()
            case let .failure(error):
                originalCompletion(.failure(error))
                updatableTask.currentTask = nil
            }
        }
    }
}

extension AuthenticationNetworkDecorator: FavoriteMovieUpdater where T: FavoriteMovieUpdater {
    func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.updateFavoriteMovie(movieId: movieId, isFavorite: isFavorite, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AuthenticationNetworkDecorator: MyFavoriteMoviePagesProvider where T: MyFavoriteMoviePagesProvider {
    func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.fetchFavoriteMovies(page: page, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AuthenticationNetworkDecorator: PopularMoviePagesProvider where T: PopularMoviePagesProvider {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchPopularMovies(page: page, completion: completion)
    }
}

extension AuthenticationNetworkDecorator: CurrentlyBroadcastMoviePagesProvider where T: CurrentlyBroadcastMoviePagesProvider {
    func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchCurrentlyBroadcastMovies(page: page, completion: completion)
    }
}
