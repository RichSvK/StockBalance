import SwiftUI

class StockBalanceViewModel: ObservableObject {
    @Published var stock: String = "BBCA"
    @Published var chartType: String = "Line"
    @Published var ip: String = "127.0.0.1:8080"
    @Published var investorType: String = "All" {
        didSet {
            filterBalance()
        }
    }
    
    @Published private var stockBalance: [StockBalance] = []
    @Published private(set) var filteredBalance: [StockSeries] = []
    var flattenedSeries: [StockSeries] = []

    init() {
        fetchStockBalance()
    }
    
    private func filterBalance() {
        switch investorType{
            case "Domestic":
                flattenedSeries = filteredBalance.filter { $0.category.contains("Local") }
                
            case "Foreign":
                flattenedSeries = filteredBalance.filter { $0.category.contains("Foreign") }
            default:
                flattenedSeries = filteredBalance
        }
    }

    func fetchStockBalance() {
        guard !stock.isEmpty else { return }
        
        let url = "http://\(ip)/balance/\(stock)"
        NetworkManager.shared.fetch(from: url, responseType: StockResponse.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.stockBalance = response.data
                    self.filteredBalance = self.stockBalance.flatMap { item in
                        [
                            StockSeries(date: item.date, value: item.localIS, category: "Local IS"),
                            StockSeries(date: item.date, value: item.localCP, category: "Local CP"),
                            StockSeries(date: item.date, value: item.localPF, category: "Local PF"),
                            StockSeries(date: item.date, value: item.localIB, category: "Local IB"),
                            StockSeries(date: item.date, value: item.localID, category: "Local ID"),
                            StockSeries(date: item.date, value: item.localMF, category: "Local MF"),
                            StockSeries(date: item.date, value: item.localSC, category: "Local SC"),
                            StockSeries(date: item.date, value: item.localFD, category: "Local FD"),
                            StockSeries(date: item.date, value: item.localOT, category: "Local OT"),
                            
                            StockSeries(date: item.date, value: item.foreignCP, category: "Foreign CP"),
                            StockSeries(date: item.date, value: item.foreignPF, category: "Foreign PF"),
                            StockSeries(date: item.date, value: item.foreignIS, category: "Foreign IS"),
                            StockSeries(date: item.date, value: item.foreignIB, category: "Foreign IB"),
                            StockSeries(date: item.date, value: item.foreignID, category: "Foreign ID"),
                            StockSeries(date: item.date, value: item.foreignMF, category: "Foreign MF"),
                            StockSeries(date: item.date, value: item.foreignSC, category: "Foreign SC"),
                            StockSeries(date: item.date, value: item.foreignFD, category: "Foreign FD"),
                            StockSeries(date: item.date, value: item.foreignOT, category: "Foreign OT"),
                        ]
                    }
                    self.filterBalance()
                }
                print("✅ Success Load \(self.stock) Data")
                
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
}
