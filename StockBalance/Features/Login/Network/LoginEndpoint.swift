import Foundation

enum LoginEndpoint {
    case login

    var path: String {
        switch self {
        case .login:
            return "http://localhost:8888/api/user/login"
        }
    }
}
