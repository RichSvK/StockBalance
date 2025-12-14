//
//  APIConfig.swift
//  StockInfo
//
//  Created by Richard Sugiharto on 15/11/25.
//

import Foundation

enum APIConfig {
    static let baseURL = Secrets.shared.backendHost
}

protocol EndpointProtocol {
    var path: String { get }
    var urlString: String { get }
    var url: URL? { get }
}

extension EndpointProtocol {
    var urlString: String {
        return (APIConfig.baseURL ?? "http://localhost") + path
    }

    var url: URL? {
        return URL(string: urlString)
    }
}
