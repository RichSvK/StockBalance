import SwiftUI

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorizedError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data in server"
        case .unauthorizedError: return "Unauthorized"
        }
    }
}
