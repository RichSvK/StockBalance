import Foundation

enum RegisterEndpoint {
    case register

    var path: String {
        switch self {
        case .register:
            return "http://localhost:8888/users/register"
        }
    }
}
