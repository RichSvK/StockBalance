import Foundation
import SwiftUI

class LoginViewModel: ObservableObject{
    var email: String = ""
    var password: String = ""
    var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showRegister: Bool = false
    
    private let session: SessionManager
    init(session: SessionManager = SessionManager.shared){
        self.session = session
    }
    
    func login(){
        let request: LoginRequest = LoginRequest(email: self.email, password: self.password)
        print(request)
        
        NetworkManager.shared.post(to: "http://localhost:8888/users/login", body: request, responseType: LoginResponse.self){ result in
            DispatchQueue.main.async{
                switch result {
                    case .success(let response):
                        if response.message == "Login Success"{
                            if let loginData = response.data{
                                NetworkManager.shared.setToken(loginData.token)
                                self.session.showLogin = false
                            }
                            return
                        }
                        print(response)
                        self.errorMessage = response.message
                        self.showAlert = true
                    
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        print("❌ Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func closeLogin(){
        self.session.showLogin = false
    }
}
