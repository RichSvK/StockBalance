import Foundation
import SwiftUI

internal class LoginViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var showAlert: Bool = false
    @Published var showRegister: Bool = false
    
    // MARK: Variables
    var email: String = ""
    var password: String = ""
    var errorMessage: String = ""
    
    func login() {
        let url: String = LoginEndpoint.login.urlString
        let request: LoginRequest = LoginRequest(email: self.email, password: self.password)
        
        NetworkManager.shared.post(to: url, body: request, responseType: LoginResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200 else {
                        self.errorMessage = "Login Failed"
                        self.showAlert = true
                        return
                    }
                    
                    if let loginData = response.data {
                        UserDefaults.standard.set(loginData.token, forKey: "token")
                    }
                
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
