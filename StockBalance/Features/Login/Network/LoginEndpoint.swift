import Foundation

enum LoginEndpoint: EndpointProtocol {
    case login

    var path: String {
        switch self {
        case .login:
            return ":8888/api/user/login"
        }
    }
}
