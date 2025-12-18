import Foundation
import SwiftUI

@MainActor
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
            
            guard statusCode == 200, let token = response.data?.token, !token.isEmpty else {
                throw NetworkError.server(message: response.message)
            }
            
            TokenManager.shared.save(token: token)
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
