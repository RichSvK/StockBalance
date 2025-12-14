import Foundation

enum ScriptlessEndpoint: EndpointProtocol {
    case getScriptlessChange

    var path: String {
        switch self {
        case .getScriptlessChange:
            return "/api/auth/balance/scriptless"
        }
    }
}
