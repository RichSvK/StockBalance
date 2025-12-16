import Foundation
import SwiftUI

internal class LoginViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var showAlert: Bool = false
    @Published var showRegister: Bool = false
    
    // MARK: Variables
    var email: String = ""
    var password: String = ""
    var alertMessage: String = ""
    
    func login() async {
        let request: LoginRequest = LoginRequest(email: self.email, password: self.password)
        
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: LoginEndpoint.login.urlString,
                method: .post,
                body: request,
                responseType: LoginResponse.self
            )
            
            Task { @MainActor in
                guard statusCode == 200, let token = response.data?.token, !token.isEmpty else {
                    self.alertMessage = response.message
                    self.showAlert = true
                    return
                }
                
                TokenManager.shared.save(token: token)
            }
        } catch {
            // Error
        }
    }
}
