import Foundation

enum WatchListEndpoint: EndpointProtocol {
    case getWatchlist
    case getStock
    
    var path: String {
        switch self {
        case .getWatchlist:
            return "/watchlist/"
        case .getStock:
            return "/stock/"
        }
    }
}
