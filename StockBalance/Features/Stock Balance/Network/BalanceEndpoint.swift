import Foundation

enum BalanceEndpoint: EndpointProtocol {
    case getStockBalance
    case addWatchlist
    case removeWatchlist
    
    var path: String {
        switch self {
        case .getStockBalance: return "/balance"
        case .addWatchlist: return "/api/auth/watchlist"
        case .removeWatchlist: return "/api/auth/watchlist"
        }
    }
}
