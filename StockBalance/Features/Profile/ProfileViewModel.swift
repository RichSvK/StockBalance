import Foundation

internal class ProfileViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var showAlert: Bool = false
    @Published var userProfile: Profile = Profile(username: "", email: "")

    // MARK: Variables    
    var alertMessage: String = ""

    func getUserProfile() {
        let url: String = "http://localhost:3000/api/auth/user/profile"
        NetworkManager.shared.fetch(from: url, responseType: ProfileResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200 else { return }
                    if let data = response.data {
                        self.userProfile = data
                    }
                                        
                case .failure(let error):
                    print("Error Access: \(error)")
                }
            }
        }
    }
    
    func logout() {
        userProfile = Profile(username: "", email: "")
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
