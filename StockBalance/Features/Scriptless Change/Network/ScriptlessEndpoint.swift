import Foundation

enum ScriptlessEndpoint {
    case getScriptlessChange

    var path: String {
        switch self {
        case .getScriptlessChange:
            return "http://localhost:3000/api/auth/balance/scriptless"
        }
    }
}
