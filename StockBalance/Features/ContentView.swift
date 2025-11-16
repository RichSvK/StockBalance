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
                    Image(systemName: "slider.horizontal.2.square.on.square")
                    Text("Scriptless")
                }
                .tag(1)
            
            BalanceChangeView(viewModel: BalanceChangeViewModel())
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Changes")
                }
                .tag(3)
            
            RootView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(2)
        }
        .tint(ColorToken.greenColor.toColor())
        .onChange(of: token) { newValue in
            if !newValue.isEmpty {
                selectedTab = 2
            }
        }
    }
}

#Preview {
    ContentView()
}
