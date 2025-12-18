import Foundation

enum BalanceEndpoint: EndpointProtocol {
    case getStockBalance
    case addWatchlist
    case removeWatchlist(String)
    
    var path: String {
        switch self {
        case .getStockBalance: return "/balance"
        case .addWatchlist: return "/api/auth/watchlist"
        case .removeWatchlist(let stock): return "/api/auth/watchlist/\(stock)"
        }
    }
}
