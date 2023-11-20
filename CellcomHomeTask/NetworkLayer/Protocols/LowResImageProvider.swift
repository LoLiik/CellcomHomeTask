//
//  LowResImageProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import Foundation

public protocol LowResImageProvider: AnyObject {
    func fetchLowResImage(imagePath: String, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
