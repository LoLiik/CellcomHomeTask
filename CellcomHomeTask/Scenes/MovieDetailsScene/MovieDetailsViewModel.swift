//
//  MovieDetailsViewModel.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import CellcomHometaskModels
import CellcomHometaskProtocols

protocol MovieDetailsViewModelProtocol: AnyObject {
    func viewLoaded()
    func addToFavorite()
    var onImageFetched: ((UIImage?) -> Void)? { get set }
    var onAddedToFavorite: (() -> Void)? { get set }
    var onMovieSet: ((Movie) -> Void)? { get set }
}

final class MovieDetailsViewModel {
    private let movie: Movie
    private let movieUpdater: FavoriteMovieUpdater
    private let highResImageProvider: HighResImageProvider
    private let router: MovieDetailsRouterProtocol
    private let updateCompletion: (Bool) -> Void
    
    private var loadingTask: CancelableDataLoadingTask?
    private var loadingPosterTask: CancelableDataLoadingTask?
    
    var onImageFetched: ((UIImage?) -> Void)?
    var onAddedToFavorite: (() -> Void)?
    var onMovieSet: ((Movie) -> Void)?
    
    private var movieWasChanged: Bool {
        true
    }
    
    init(
        movie: Movie,
        movieUpdater: FavoriteMovieUpdater,
        highResImageProvider: HighResImageProvider,
        router: MovieDetailsRouterProtocol,
        updateCompletion: @escaping (Bool) -> Void
    ) {
        self.movie = movie
        self.movieUpdater = movieUpdater
        self.highResImageProvider = highResImageProvider
        self.router = router
        self.updateCompletion = updateCompletion
    }
}

import UIKit

protocol MovieDetailsViewProtocol: AnyObject {
    func movieWasAddedToFavorite()
    func updateImage(with image: UIImage?)
}

extension MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    func viewLoaded() {
        onMovieSet?(movie)
        
        guard let imagePath = movie.posterPath else { return }
        loadingPosterTask = highResImageProvider.fetchHighResImage(imagePath: imagePath) { [weak self] result in
            switch result {
            case let .success(imageData):
                let image = UIImage(data: imageData)
                self?.onImageFetched?(image)
            case .failure:
                break
            }
        }
    }
    
    func addToFavorite() {
        loadingTask = movieUpdater.updateFavoriteMovie(movieId: movie.id, isFavorite: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateCompletion(self.movieWasChanged)
                self.onAddedToFavorite?()
            case let .failure(error):
                self.router.displayError(error)
            }
            
        }
    }
}
