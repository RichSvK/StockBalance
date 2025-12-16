import Foundation

enum ProfileEndpoint: EndpointProtocol {
    case getProfile

    var path: String {
        switch self {
        case .getProfile:
            return "/api/auth/user/profile"
        }
    }
}
