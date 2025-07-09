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
        }
        .fullScreenCover(isPresented: $session.showLogin) {
            LoginView()
        }
    }
}
