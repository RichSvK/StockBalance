import Foundation

internal class RegisterViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var username: String = ""

    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var registrationSuccess: Bool = false

    func register() {
        let url: String = RegisterEndpoint.register.path
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
