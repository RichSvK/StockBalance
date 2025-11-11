import SwiftUI

@main
struct StockBalanceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(.xSmall ... .large)
        }
    }
}
