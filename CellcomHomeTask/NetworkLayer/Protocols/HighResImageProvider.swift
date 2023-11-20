//
//  HighResImageProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 20.11.2023.
//

import Foundation

public protocol HighResImageProvider: AnyObject {
    func fetchHighResImage(imagePath: String, completion: @escaping (Result<Data, MovieFetchingError>) -> Void) -> DataLoadingTask?
}

