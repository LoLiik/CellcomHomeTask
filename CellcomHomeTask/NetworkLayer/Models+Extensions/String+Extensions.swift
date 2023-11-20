//
//  String+Extensions.swift
//  CellcomHomeTask
//
//  Created by Евгений Кулиничев on 19.11.2023.
//

import Foundation

extension String {
    var url: URL? {
        URL(string: self)
    }
    
    func addParameter(parameterName: String, value: Int) -> String {
        return "\(self)&\(parameterName)=\(value)"
    }
    
    func addParameter(parameterName: String, value: String) -> String {
        return "\(self)&\(parameterName)=\(value)"
    }
}
