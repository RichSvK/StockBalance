import Foundation

enum ProfileEndpoint: EndpointProtocol {
    case getProfile

    var path: String {
        switch self {
        case .getProfile:
            return "http://localhost:3000/api/auth/user/profile"
        }
    }
}
