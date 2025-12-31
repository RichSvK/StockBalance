import Foundation

enum BalanceEndpoint: EndpointProtocol {
    case getStockBalance(String)
    case addWatchlist
    case removeWatchlist(String)
    
    var path: String {
        switch self {
        case .getStockBalance(let stock): return "/balance/\(stock)"
        case .addWatchlist: return "/api/auth/watchlist"
        case .removeWatchlist(let stock): return "/api/auth/watchlist/\(stock)"
        }
    }
}
