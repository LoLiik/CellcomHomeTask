//
//  LowResImageProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import CellcomHomeTaskModels

public protocol LowResImageProvider: AnyObject {
    func fetchLowResImage(imagePath: String, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
