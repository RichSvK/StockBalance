import Foundation

internal class RegisterViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var registrationSuccess: Bool = false
    
    // MARK: Variables
    var email: String = ""
    var password: String = ""
    var username: String = ""

    func register() {
        let url: String = RegisterEndpoint.register.urlString
        let requestBody: RegisterRequest = RegisterRequest(email: self.email, password: self.password, username: self.username)
        
        NetworkManager.shared.post(to: url, body: requestBody, responseType: RegisterResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200 else {
                        self.errorMessage = response.message
                        self.showAlert = true
                        return
                    }
                    self.registrationSuccess = true

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}
