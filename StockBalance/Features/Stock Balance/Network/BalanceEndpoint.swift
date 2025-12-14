import Foundation

enum BalanceEndpoint: EndpointProtocol {
    case getStockBalance
    case updateWatchlist
    
    var path: String {
        switch self {
        case .getStockBalance: return "/balance/"
        case .updateWatchlist: return "/watchlist/"
        }        
    }
}
