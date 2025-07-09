import SwiftUI

class SessionManager: ObservableObject {
    static var shared = SessionManager()
    
    @AppStorage("token") var token: String = ""
    @AppStorage("loggedIn") var showLogin: Bool = false

    init() {}
}
