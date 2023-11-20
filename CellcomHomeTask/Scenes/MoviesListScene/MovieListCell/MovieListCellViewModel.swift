//
//  MovieListCellViewModel.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import UIKit

final class MovieListCellViewModel {
    private let movie: Movie
    private let lowResPosterProvider: LowResImageProvider
    private var imageLoadDataTask: DataLoadingTask?
    
    var movieName: String { movie.title }
    
    init(
        movie: Movie,
        lowResPosterProvider: LowResImageProvider
    ) {
        self.movie = movie
        self.lowResPosterProvider = lowResPosterProvider
    }
    
    weak var view: MovieListCell? {
        didSet {
            fetchPoster()
        }
    }
    
    func cancelLoad() {
        imageLoadDataTask?.cancel()
        imageLoadDataTask = nil
        view = nil
    }
    
    private func fetchPoster() {
        guard let posterPath = movie.posterPath else { return }
        imageLoadDataTask = lowResPosterProvider.fetchLowResImage(imagePath: posterPath) { [weak self] result in
            if case let .success(imageData) = result, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.view?.setImage(image)
                }
            }
        }
    }
}
