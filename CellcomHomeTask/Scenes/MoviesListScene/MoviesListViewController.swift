//
//  MoviesListViewController.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import UIKit

final class MoviesListViewController: UITableViewController {
    let viewModel: MoviesListViewModelProtocol
    
    init(viewModel: MoviesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSegmentedControl()
        viewModel.viewLoaded()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.reuseIdentifier)
    }
    
    private func setupSegmentedControl() {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Popular", "Current", "My Favorites"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentTintColor = UIColor.red
        segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewModel.currentListType = .popular
        } else if sender.selectedSegmentIndex == 1 {
            viewModel.currentListType = .currentBroadcast
        } else if sender.selectedSegmentIndex == 2 {
            viewModel.currentListType = .myFavorites
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesListViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIdentifier) as? MovieListCell else { return UITableViewCell() }
        viewModel.setup(cell: cell, at: indexPath)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieListCell else { return }
        cell.cancelLoad()
    }
}

extension MoviesListViewController: MoviesListView {
    func updateMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayError(_ error: MovieFetchingError) {
        
    }
}
