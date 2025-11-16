//
//  APIConfig.swift
//  StockInfo
//
//  Created by Richard Sugiharto on 15/11/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "http://127.0.0.1:8080/"
}

protocol EndpointProtocol {
    var path: String { get }
    var urlString: String { get }
    var url: URL? { get }
}

extension EndpointProtocol {
    var urlString: String {
        return APIConfig.baseURL + path
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
