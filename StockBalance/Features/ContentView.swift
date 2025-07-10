import SwiftUI

struct ContentView: View {
    @StateObject var session: SessionManager = SessionManager.shared

    var body: some View {
        TabView{
            StockBalanceView(viewModel: StockBalanceViewModel())
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ScriptlessChangeView(viewModel: ScriptlessChangeViewModel())
                .tabItem{
                    Image(systemName: "pencil")
                    Text("Scriptless")
                }
            
            ProfileView()
                .tabItem{
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .fullScreenCover(isPresented: $session.showLogin) {
            LoginView()
        }
    }
}
