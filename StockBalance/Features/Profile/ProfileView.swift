import SwiftUI

struct ProfileView: View {
    @StateObject private var session: SessionManager = SessionManager.shared
    @StateObject private var viewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            if session.userProfile.username == "" {
                LoginView()
            } else {
                VStack(alignment: .center){
                    Text("Profile View")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack{
                        Text("Username")
                        Spacer()
                        Text(session.userProfile.username)
                    }
                    .padding(.vertical, 10)
                    
                    HStack{
                        Text("Email")
                        Spacer()
                        Text(session.userProfile.email)
                    }
                    .padding(.vertical, 10)
                    
                    Button(action: {
                        session.logout()
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
        .onAppear{
            session.getUserProfile()
        }
    }
}
