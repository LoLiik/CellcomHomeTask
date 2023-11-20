//
//  GuestSessionProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol GuestSessionProvider: AnyObject {
    func generateGuestSession(completion: @escaping (Result<GuestSession, MovieFetchingError>) -> Void) -> DataLoadingTask?
}
