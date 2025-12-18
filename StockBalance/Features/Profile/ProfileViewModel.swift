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
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: ProfileEndpoint.getProfile.urlString,
                method: .get,
                responseType: ProfileResponse.self
            )
            
            guard statusCode == 200, let data = response.data else {
                throw NetworkError.server(message: response.message)
            }
            
            userProfile = data
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
