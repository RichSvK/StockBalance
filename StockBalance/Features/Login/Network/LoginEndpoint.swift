import Foundation

enum LoginEndpoint: EndpointProtocol {
    case login

    var path: String {
        switch self {
        case .login:
            return "/api/user/login"
        }
    }
}
