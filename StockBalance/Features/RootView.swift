import SwiftUI

struct RootView: View {
    @AppStorage("token") var token: String = ""

    var body: some View {
        if token.isEmpty {
            LoginView()
        } else {
            ProfileView()
        }
    }
}
