//
//  NetworkWorker+HighResImageProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: HighResImageProvider {
    public func fetchHighResImage(imagePath: String, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        let urlPath = "\(Paths.highResMoviePoster)\(imagePath)"
        guard let url = urlPath.url else { return nil }
        return fetchData(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static var highResMoviePoster: String { "https://image.tmdb.org/t/p/original"}
}

