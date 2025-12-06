import Foundation

enum WatchListEndpoint {
    case getWatchlist

    var path: String {
        switch self {
        case .getWatchlist:
            return "http://localhost:8080/watchlist/"
        }
    }
}
