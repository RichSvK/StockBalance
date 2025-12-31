import Foundation

@MainActor
internal class ProfileViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var showAlert: Bool = false
    @Published var userProfile: Profile = Profile(username: "", email: "")
    
    // MARK: Variables
    var alertMessage: String = ""

    func getUserProfile() async {
        do {
            let (response, _) = try await NetworkManager.shared.request(
                urlString: ProfileEndpoint.getProfile.urlString,
                method: .get,
                responseType: ProfileResponse.self
            )
            
            userProfile = Profile(username: response.username, email: response.email)
            
        } catch {
            // Error
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func logout() {
        userProfile = Profile(username: "", email: "")
        TokenManager.shared.clear()
    }
}
