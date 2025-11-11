import Foundation

enum ScriptlessEndpoint {
    case getScriptlessChange

    var path: String {
        switch self {
        case .getScriptlessChange:
            return "http://localhost:8080/api/auth/balance/scriptless"
        }
    }
}
