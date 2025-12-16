import Foundation

internal class RegisterViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var showAlert: Bool = false
    @Published var registrationSuccess: Bool = false
    
    // MARK: Variables
    var alertMessage: String = ""
    var email: String = ""
    var password: String = ""
    var username: String = ""

    func register() async {
        let requestBody: RegisterRequest = RegisterRequest(email: self.email, password: self.password, username: self.username)
        
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: RegisterEndpoint.register.urlString,
                method: .post,
                body: requestBody,
                responseType: RegisterResponse.self
            )
            
            Task { @MainActor in
                guard statusCode == 200 else {
                    alertMessage = response.message
                    showAlert = true
                    throw NetworkError.invalidResponse
                }
                registrationSuccess = true
            }
        } catch {
            // Error
        }
    }
}
