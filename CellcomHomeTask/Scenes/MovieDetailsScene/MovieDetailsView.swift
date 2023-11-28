//
//  MovieDetailsView.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

import UIKit

final class MovieDetailsView: UIView {
    var favoriteButtonTappedHandler: (() -> Void)?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var moviePosterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let addToFavoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(favoriteButtonWasTapped), for: .touchUpInside)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add To Favorite", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        layoutSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMovie(_ movie: Movie) {
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
    }
    
    func updateImage(with image: UIImage?) {
        moviePosterView.image = image
    }
    
    func hideButton() {
        addToFavoriteButton.isHidden = true
    }
    
    @objc
    private func favoriteButtonWasTapped() {
        favoriteButtonTappedHandler?()
    }
    
    private func layoutSubViews() {
        addSubview(containerView)
        containerView.addSubview(movieNameLabel)
        containerView.addSubview(moviePosterView)
        containerView.addSubview(movieDescriptionLabel)
        containerView.addSubview(addToFavoriteButton)
        
        let marginGuide = containerView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            moviePosterView.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            moviePosterView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 15),
            moviePosterView.widthAnchor.constraint(equalToConstant: 200),
            moviePosterView.heightAnchor.constraint(equalToConstant: 300),
            
            movieNameLabel.centerXAnchor.constraint(equalTo: marginGuide.centerXAnchor),
            movieNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: marginGuide.leadingAnchor, constant: 5),
            movieNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: marginGuide.trailingAnchor, constant: 5),
            movieNameLabel.topAnchor.constraint(equalTo: moviePosterView.bottomAnchor, constant: 15),
            movieNameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
            
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 5),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -5),
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 5),
            
            addToFavoriteButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            addToFavoriteButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            addToFavoriteButton.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 5),
            addToFavoriteButton.bottomAnchor.constraint(greaterThanOrEqualTo: marginGuide.bottomAnchor, constant: -15),
        ])
        
        // during dev, so we can easily see the frames
        moviePosterView.backgroundColor = .systemBlue
        movieNameLabel.backgroundColor = .cyan
    }
}
