//
//  NetworkError.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

import SwiftUI

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorizedError
    case invalidResponse
    case notLoggedIn
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data in server"
        case .unauthorizedError: return "Unauthorized"
        case .invalidResponse: return "Invalid server response"
        case .notLoggedIn: return "You are not logged in. Please sign in to continue."
        }
    }
}
