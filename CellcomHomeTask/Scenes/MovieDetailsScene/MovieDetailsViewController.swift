//
//  MovieDetailsViewController.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    let viewModel: MovieDetailsViewModelProtocol
    lazy var movieDetailsView = MovieDetailsView()
    
    override func loadView() {
        view = movieDetailsView
    }
    
    init(viewModel: MovieDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewLoaded()
    }
    
    private func bind() {
        movieDetailsView.favoriteButtonTappedHandler = { [weak self] in
            self?.viewModel.addToFavorite()
        }
        
        viewModel.onImageFetched = { [weak self] image in
            DispatchQueue.main.async {
                self?.movieDetailsView.updateImage(with: image)
            }
        }
        
        viewModel.onMovieSet = { [weak self] movie in
            DispatchQueue.main.async {
                self?.movieDetailsView.updateMovie(movie)
            }
        }
        
        viewModel.onAddedToFavorite = { [weak self] in
            DispatchQueue.main.async {
                self?.movieDetailsView.hideButton()
            }
        }
    }
}

