//
//  File.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import UIKit

public final class MovieListCell: UITableViewCell {
    static var reuseIdentifier: String {
        Self.description()
    }
    
    private let cellMargin = 15.0
    
    private var viewModel: MovieListCellViewModel?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold) // UIFont.movieAppBoldFont(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

        layoutSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        viewModel?.cancelLoad()
        viewModel = nil
        movieImageView.image = nil
        movieNameLabel.text = nil
    }
    
    func setup(with viewModel: MovieListCellViewModel) {
        self.viewModel = viewModel
        movieNameLabel.text = viewModel.movieName
    }
    
    func setImage(_ image: UIImage) {
        movieImageView.image = image
    }
    
    func cancelLoad() {
        viewModel?.cancelLoad()
    }
    
    private func layoutSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(movieNameLabel)
        containerView.addSubview(movieImageView)
        
        let marginGuide = containerView.layoutMarginsGuide
        
        let bottomC = containerView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -cellMargin)
        bottomC.priority = .required - 1
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bottomC,
            
            movieImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 5),
            movieImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            movieImageView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -5),
            movieImageView.widthAnchor.constraint(equalToConstant: 50),
            movieImageView.heightAnchor.constraint(equalToConstant: 50),
            
            movieNameLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 5),
            movieNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -5),
            movieNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            movieNameLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -5)
        ])
        
        // during dev, so we can easily see the frames
        movieImageView.backgroundColor = .systemBlue
        movieNameLabel.backgroundColor = .cyan
    }
    
}
