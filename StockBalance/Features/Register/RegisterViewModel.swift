import Foundation

@MainActor
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
            
            guard statusCode == 200 else {
                throw NetworkError.server(message: response.message)
            }
            
            await MainActor.run {
                registrationSuccess = true
            }
        } catch {
            // Error
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
