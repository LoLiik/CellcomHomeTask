//
//  CancelableDataLoadingTask.swift
//  CellcomHometaskProtocols
//
//  Created by Евгений Кулиничев on 28.11.2023.
//

public protocol CancelableDataLoadingTask: AnyObject {
    func cancel()
}
