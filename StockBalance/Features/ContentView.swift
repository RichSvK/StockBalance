import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @AppStorage("token") private var token: String = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            StockBalanceView(viewModel: StockBalanceViewModel())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ScriptlessChangeView(viewModel: ScriptlessChangeViewModel())
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Scriptless")
                }
                .tag(1)
            
            RootView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(2)
        }
        .onChange(of: token) { newValue in
            if !newValue.isEmpty {
                selectedTab = 2
            }
        }
    }
}
