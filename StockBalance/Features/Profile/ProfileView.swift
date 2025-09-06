import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    @AppStorage("token") private var token: String = ""

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Group {
                if token == "" || viewModel.userProfile.username == "" {
                    LoginView()
                } else {
                    VStack(alignment: .center) {
                        Text("Profile View")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Username")
                            Spacer()
                            Text(viewModel.userProfile.username)
                        }
                        .padding(.vertical, 10)
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(viewModel.userProfile.email)
                        }
                        .padding(.vertical, 10)
                        
                        Button(action: {
                            viewModel.logout()
                        }, label: {
                            Text("Logout")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.red)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        })
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.getUserProfile()
            print("Token: \(token)")
        }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
