//
//  File.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

public protocol ErrorData: Equatable {
    var statusCode: Int { get }
    var statusMessage: String { get }
}
