import Foundation

enum RegisterEndpoint: EndpointProtocol {
    case register

    var path: String {
        switch self {
        case .register:
            return ":8888/users/register"
        }
    }
}
