import Foundation

enum BalanceEndpoint {
    case getStockBalance

    var path: String {
        switch self {
        case .getStockBalance:
            return "http://localhost:8080/balance/"
        }
    }
}
