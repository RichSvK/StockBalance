import Foundation

enum ProfileEndpoint: EndpointProtocol {
    case getProfile

    var path: String {
        switch self {
        case .getProfile:
            return ":8888/api/auth/user/profile"
        }
    }
}
