//
//  MoviesPageWorker.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 27.11.2023.
//


class MoviesPageWorker {
    typealias FetchMoviePageHandler = (Int, @escaping (Result<MovieList, MovieFetchingError>) -> Void) -> DataLoadingTask?
    
    private(set) var movies: [Movie] = []
    
    var haveMorePages: Bool {
        currentPage < totalPagesCount
    }
    
    private var currentPage: Int = 0
    private var totalPagesCount = 1
    private var nextPage: Int {
        currentPage + 1
    }
    private var isPaginating: Bool = false
    
    private let fetchMoviePage: FetchMoviePageHandler
    
    init(fetchMoviePage: @escaping FetchMoviePageHandler) {
        self.fetchMoviePage = fetchMoviePage
    }
}

extension MoviesPageWorker: MoviesProvider {
    func resetData() {
        movies = []
        currentPage = 0
        totalPagesCount = 1
        isPaginating = false
    }
    
    func fetchMovies(completion: @escaping (Result<Void, MovieFetchingError>) -> Void) -> DataLoadingTask? {
        guard !isPaginating else { return nil }
        isPaginating = true
        return fetchMoviePage(nextPage, { [weak self] result in
            guard let self = self else { return }
            self.isPaginating = false
            switch result {
            case let .success(movieList):
                if let currentPage = movieList.currentPage {
                    self.currentPage = currentPage
                } else {
                    self.currentPage += 1
                }
                self.totalPagesCount = movieList.totalPagesCount
                self.movies.append(contentsOf: movieList.movies)
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
