//
//  SessionUpdater.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

public protocol SessionUpdater: AnyObject {
    func updateSessionId(_ sessionId: String)
}
