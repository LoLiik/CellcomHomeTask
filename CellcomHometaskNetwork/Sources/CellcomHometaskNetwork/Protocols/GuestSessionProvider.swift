//
//  GuestSessionProvider.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import CellcomHometaskModels
import CellcomHometaskProtocols

protocol GuestSessionProvider: AnyObject {
    func generateGuestSession(completion: @escaping (Result<GuestSession, MovieFetchingError>) -> Void) -> CancelableDataLoadingTask?
}
