import Foundation

class RegisterViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var username: String = ""

    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var registrationSuccess: Bool = false

    func register() {
        let requestBody: RegisterRequest = RegisterRequest(email: self.email, password: self.password, username: self.username)
        
        NetworkManager.shared.post(to: "http://10.60.54.8:8888/users/register", body: requestBody, responseType: RegisterResponse.self){ result in
            DispatchQueue.main.async {
                switch(result) {
                    case .success(let response):
                        if response.message != "Register Success"{
                            self.errorMessage = response.message
                            self.showAlert = true
                        } else{
                            self.registrationSuccess = true
                        }

                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        print(error)
                }
            }
        }
    }
}
