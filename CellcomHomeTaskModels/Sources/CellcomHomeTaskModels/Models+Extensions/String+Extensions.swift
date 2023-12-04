//
//  String+Extensions.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

extension String {
    public var url: URL? {
        URL(string: self)
    }
    
    public func addParameter(parameterName: String, value: Int) -> String {
        return "\(self)&\(parameterName)=\(value)"
    }
    
    public func addParameter(parameterName: String, value: String) -> String {
        return "\(self)&\(parameterName)=\(value)"
    }
}
