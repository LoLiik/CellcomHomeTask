//
//  AccountDetailsProviderNetworkDecorator.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

/// Decorate type to request account details  if needed and repeat type request
final class AccountDetailsProviderNetworkDecorator<T> {
    private let decoratee: T
    private let accountDetailsProvider: AccountDetailsProvider
    
    init(decoratee: T, accountDetailsProvider: AccountDetailsProvider) {
        self.decoratee = decoratee
        self.accountDetailsProvider = accountDetailsProvider
    }
    
    private func decorate<G>(actionForDecoration: @escaping (@escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask?, originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return actionForDecoration { [weak self] result in
            if case let .failure(movieFetchingError) = result,
                movieFetchingError == .noAccountId {
                self?.fetchAccount(decoratedAction: {
                    _ = actionForDecoration(originalCompletion)
                }, originalCompletion: originalCompletion)
            } else {
                originalCompletion(result)
            }
        }
    }
    
    @discardableResult
    private func fetchAccount<G>(decoratedAction: @escaping () -> Void, originalCompletion: @escaping (Result<G, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return accountDetailsProvider.fetchAccountDetails() { accountDetailsResult in
            switch accountDetailsResult {
            case .success:
                decoratedAction()
            case let .failure(error):
                originalCompletion(.failure(error))
            }
        }
    }
}

extension AccountDetailsProviderNetworkDecorator: FavoriteMovieUpdater where T: FavoriteMovieUpdater {
    func updateFavoriteMovie(movieId: Int, isFavorite: Bool, completion: @escaping (Result<TMDBResponse, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.updateFavoriteMovie(movieId: movieId, isFavorite: isFavorite, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}

extension AccountDetailsProviderNetworkDecorator: PopularMoviesProvider where T: PopularMoviesProvider {
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchPopularMovies(page: page, completion: completion)
    }
}

extension AccountDetailsProviderNetworkDecorator: CurrentlyBroadcastMoviesProvider where T: CurrentlyBroadcastMoviesProvider {
    func fetchCurrentlyBroadcastMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decoratee.fetchCurrentlyBroadcastMovies(page: page, completion: completion)
    }
}

extension AccountDetailsProviderNetworkDecorator: MyFavoriteMoviesProvider where T: MyFavoriteMoviesProvider {
    func fetchFavoriteMovies(page: Int, completion: @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        return decorate(
            actionForDecoration: { [weak self] decoratedCompletion in
                return self?.decoratee.fetchFavoriteMovies(page: page, completion: decoratedCompletion)
            },
            originalCompletion: completion
        )
    }
}
