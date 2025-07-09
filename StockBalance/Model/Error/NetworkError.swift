import SwiftUI

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData

    var errorDescription: String? {
        switch self {
            case .invalidURL: return "URL tidak valid."
            case .noData: return "Tidak ada data dari server."
        }
    }
}
