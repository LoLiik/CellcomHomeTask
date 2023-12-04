//
//  NetworkWorker+LowResImageProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import CellcomHomeTaskModels
import CellcomHometaskProtocols

extension NetworkWorker: LowResImageProvider {
    public func fetchLowResImage(imagePath: String, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask? {
        let urlPath = "\(Paths.lowResMoviePoster)\(imagePath)"
        guard let url = urlPath.url else { return nil }
        return fetchData(url: url, completion: completion)
    }
}

extension NetworkWorker.Paths {
    static var lowResMoviePoster: String { "https://image.tmdb.org/t/p/w154"}
}
