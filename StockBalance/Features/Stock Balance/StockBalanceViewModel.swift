import SwiftUI

internal class StockBalanceViewModel: ObservableObject {
    // MARK: Published variables
    @Published private var stockBalance: [StockBalance] = []
    @Published private(set) var filteredBalance: [StockSeries] = []
    @Published var showAlert: Bool = false
    @Published var investorType: String = "All" {
        didSet {
            filterBalance()
        }
    }
    
    // MARK: Variable
    var flattenedSeries: [StockSeries] = []
    var alertMessage: String = ""
    var stock: String = "BBCA"
    
    init() {
        fetchStockBalance()
        filterBalance()
    }
    
    private struct RawSeries {
        let value: UInt64
        let investorType: Int
        let category: String
    }

    private func filterBalance() {
        switch investorType {
        case "All":
            self.filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0, includeSummary: true)
            }
            self.flattenedSeries = self.filteredBalance

        default:
            self.filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0)
            }

            self.flattenedSeries = self.filteredBalance.filter {$0.investorType == (self.investorType == "Domestic" ? 1 : 2)}
        }
    }

    func fetchStockBalance() {
        guard !stock.isEmpty else {
            DispatchQueue.main.async {
                self.alertMessage = "Please enter a stock code"
                self.showAlert = true
            }
            return
        }

        let url: String = "\(BalanceEndpoint.getStockBalance.path)\(stock)"
        
        NetworkManager.shared.fetch(from: url, responseType: StockResponse.self) { result in
            switch result {
            case .success(let (response, statusCode)):
                guard statusCode == 200 else {
                    print("❌ Status Code: \(statusCode)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.stockBalance = response.data
                    self.filterBalance()
                }
                print("✅ Success Load \(self.stock) Data")

            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func extractSeries(from item: StockBalance, includeSummary: Bool = false) -> [StockSeries] {
        let rawSeries: [RawSeries] = [
            RawSeries(value: item.localIS, investorType: 1, category: "Insurance"),
            RawSeries(value: item.localCP, investorType: 1, category: "Corporate"),
            RawSeries(value: item.localPF, investorType: 1, category: "Pension Fund"),
            RawSeries(value: item.localIB, investorType: 1, category: "Bank"),
            RawSeries(value: item.localID, investorType: 1, category: "Individual"),
            RawSeries(value: item.localMF, investorType: 1, category: "Mutual Fund"),
            RawSeries(value: item.localSC, investorType: 1, category: "Securities"),
            RawSeries(value: item.localFD, investorType: 1, category: "Foundation"),
            RawSeries(value: item.localOT, investorType: 1, category: "Other"),

            RawSeries(value: item.foreignIS, investorType: 2, category: "Insurance"),
            RawSeries(value: item.foreignCP, investorType: 2, category: "Corporate"),
            RawSeries(value: item.foreignPF, investorType: 2, category: "Pension Fund"),
            RawSeries(value: item.foreignIB, investorType: 2, category: "Bank"),
            RawSeries(value: item.foreignID, investorType: 2, category: "Individual"),
            RawSeries(value: item.foreignMF, investorType: 2, category: "Mutual Fund"),
            RawSeries(value: item.foreignSC, investorType: 2, category: "Securities"),
            RawSeries(value: item.foreignFD, investorType: 2, category: "Foundation"),
            RawSeries(value: item.foreignOT, investorType: 2, category: "Other")
        ]

        let detailed = rawSeries.compactMap { series -> StockSeries? in
            guard series.value != 0 else { return nil }
            return StockSeries(date: item.date, value: Double(series.value) / Double(item.listedShares) * 100, category: series.category, investorType: series.investorType)
        }

        if includeSummary {
            let totalDomestic = rawSeries.filter { $0.investorType == 1 }.map(\.value).reduce(0, +)
            let totalForeign  = rawSeries.filter { $0.investorType == 2 }.map(\.value).reduce(0, +)

            let summary: [StockSeries] = [
                totalDomestic > 0 ? StockSeries(date: item.date, value: Double(totalDomestic) / Double(item.listedShares) * 100, category: "Domestic", investorType: 1) : nil,
                totalForeign > 0  ? StockSeries(date: item.date, value: Double(totalForeign) / Double(item.listedShares) * 100, category: "Foreign", investorType: 2) : nil
            ].compactMap { $0 }

            return summary
        }

        return detailed
    }
}
