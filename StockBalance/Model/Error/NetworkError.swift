import SwiftUI

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData

    var errorDescription: String? {
        switch self {
            case .invalidURL: return "Invalid URL"
            case .noData: return "No data in server."
        }
    }
}
