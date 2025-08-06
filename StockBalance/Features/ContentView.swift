import SwiftUI

struct ContentView: View {
    @StateObject var session: SessionManager = SessionManager.shared
    
    var body: some View {
        TabView(selection: $session.tabTag){
            StockBalanceView(viewModel: StockBalanceViewModel())
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ScriptlessChangeView(viewModel: ScriptlessChangeViewModel())
                .tabItem{
                    Image(systemName: "pencil")
                    Text("Scriptless")
                }
                .tag(1)
            
            ProfileView()
                .tabItem{
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}
