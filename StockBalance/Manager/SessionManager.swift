import SwiftUI

final class SessionManager: ObservableObject {
    static var shared = SessionManager()
    
    @AppStorage("token") var token: String = ""
    @AppStorage("loggedIn") var showLogin: Bool = false

    /// Singleton
    private init() {}
    
    func logout(){
        token = ""
        showLogin = true
    }
}
