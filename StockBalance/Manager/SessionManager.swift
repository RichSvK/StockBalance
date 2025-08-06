import SwiftUI

final class SessionManager: ObservableObject {
    static var shared: SessionManager = SessionManager()
    
    @AppStorage("token") var token: String = ""
    @AppStorage("loggedIn") var tabTag: Int = 0

    /// Singleton
    private init() {}
    
    func logout(){
        token = ""
        tabTag = 2
        userProfile = Profile(username: "", email: "")
    }

    @Published var userProfile: Profile = Profile(username: "", email: "")
    
    func getUserProfile() {
        let url: String = "http://10.60.51.187:3000/api/auth/user/profile"
        NetworkManager.shared.fetch(from: url, responseType: ProfileResponse.self){ result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let response):
                        if let data = response.data {
                            self.userProfile = data
                        }
                        print(response)
                        
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
