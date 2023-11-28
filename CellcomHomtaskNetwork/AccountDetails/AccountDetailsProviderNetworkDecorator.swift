//
//  AccountDetailsProviderNetworkDecorator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

/// Decorate type to request account details  if needed and repeat type request
public final class AccountDetailsProviderNetworkDecorator<T> {
    private let decoratee: T
    private let accountDetailsProvider: AccountDetailsProvider
    
    public init(decoratee: T, accountDetailsProvider: AccountDetailsProvider) {
        self.decoratee = decoratee
        self.accountDetailsProvider = accountDetailsProvider
    }
    
    /// Separate original action (request) from original completion
    ///  and wrapping original action with getting accountID
    /// - Parameters:
    ///   - actionForDecoration: closure that receives closure of completion
    ///   - originalCompletion: closure handling result of original action
    /// - Returns: task object for cancelation at any moment
    private func decorate<G>(actionForDecoration: @escaping (@escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask?, originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        // 1. Creating new task wrapper to be able to cancel current task at any moment
        let updatableTask = UpdatableCancebleTaskProxy()
        // 2. Executing original action with wrapped completion and saving reference for its task to cancel
        let currentTask = actionForDecoration { [weak self] result in
            // if we failed with no account error = we are trying to fetch account first and then repeat original request
            if case let .failure(movieFetchingError) = result,
                movieFetchingError == .noAccountId {
                self?.fetchAccount(
                    decoratedAction: {
                        updatableTask.currentTask = actionForDecoration(originalCompletion)
                    },
                    originalCompletion: originalCompletion,
                    updatableTask: updatableTask
                )
            // otherwise we are processing original request result
            } else {
                originalCompletion(result)
            }
        }
        
        // 3. Updating our task wrapper with task of executing original action with wrapped completion
        updatableTask.currentTask = currentTask
        return updatableTask
    }
    
    private func fetchAccount<G>(
        decoratedAction: @escaping () -> Void,
        originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void,
        updatableTask: DataLoadingTaskUpdatable
    ) {
        let currentTask = accountDetailsProvider.fetchAccountDetails() { accountDetailsResult in
            switch accountDetailsResult {
            case .success:
                decoratedAction()
            case let .failure(error):
                originalCompletion(.failure(error))
                updatableTask.currentTask = nil
            }
        }
        updatableTask.currentTask = currentTask
    }
}

extension AccountDetailsProviderNetworkDecorator: FavoriteMovieUpdater where T: FavoriteMovieUpdater {
    public func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.updateFavoriteMovie(movieId: movieId, isFavorite: isFavorite, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AccountDetailsProviderNetworkDecorator: PopularMoviePagesProvider where T: PopularMoviePagesProvider {
    public func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchPopularMovies(page: page, completion: completion)
    }
}

extension AccountDetailsProviderNetworkDecorator: CurrentlyBroadcastMoviePagesProvider where T: CurrentlyBroadcastMoviePagesProvider {
    public func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchCurrentlyBroadcastMovies(page: page, completion: completion)
    }
}

extension AccountDetailsProviderNetworkDecorator: MyFavoriteMoviePagesProvider where T: MyFavoriteMoviePagesProvider {
    public func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.fetchFavoriteMovies(page: page, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}
