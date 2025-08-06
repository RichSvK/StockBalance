import SwiftUI

class StockBalanceViewModel: ObservableObject {
    var stock: String = "BBCA"
    var ip: String = "10.60.51.187:8080"
    
    @Published var investorType: String = "All" {
        didSet {
            filterBalance()
        }
    }

    @Published private var stockBalance: [StockBalance] = []
    @Published private(set) var filteredBalance: [StockSeries] = []
    var flattenedSeries: [StockSeries] = []

    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    let session: SessionManager

    init(session: SessionManager = SessionManager.shared) {
        self.session = session
        fetchStockBalance()
        filterBalance()
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

        let url = "http://\(ip)/balance/\(stock)"
        NetworkManager.shared.fetch(from: url, responseType: StockResponse.self) { result in
            switch result {
                case .success(let response):
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
        let rawSeries: [(UInt64, Int, String)] = [
            (item.localIS, 1, "Insurance"),
            (item.localCP, 1, "Corporate"),
            (item.localPF, 1, "Pension Fund"),
            (item.localIB, 1, "Bank"),
            (item.localID, 1, "Individual"),
            (item.localMF, 1, "Mutual Fund"),
            (item.localSC, 1, "Securities"),
            (item.localFD, 1, "Foundation"),
            (item.localOT, 1, "Other"),

            (item.foreignIS, 2, "Insurance"),
            (item.foreignCP, 2, "Corporate"),
            (item.foreignPF, 2, "Pension Fund"),
            (item.foreignIB, 2, "Bank"),
            (item.foreignID, 2, "Individual"),
            (item.foreignMF, 2, "Mutual Fund"),
            (item.foreignSC, 2, "Securities"),
            (item.foreignFD, 2, "Foundation"),
            (item.foreignOT, 2, "Other"),
        ]

        let detailed = rawSeries.compactMap { (value, type, category) -> StockSeries? in
            value != 0 ? StockSeries(date: item.date, value: Double(value) / Double(item.listedShares) * 100, category: category, investorType: type) : nil
        }

        if includeSummary {
            let totalDomestic = rawSeries.filter { $0.1 == 1 }.map { $0.0 }.reduce(0, +)
            let totalForeign  = rawSeries.filter { $0.1 == 2 }.map { $0.0 }.reduce(0, +)

            let summary: [StockSeries] = [
                totalDomestic > 0 ? StockSeries(date: item.date, value: Double(totalDomestic) / Double(item.listedShares) * 100, category: "Domestic", investorType: 1) : nil,
                totalForeign > 0  ? StockSeries(date: item.date, value: Double(totalForeign) / Double(item.listedShares) * 100, category: "Foreign", investorType: 2) : nil,
            ].compactMap { $0 }

            return summary
        }

        return detailed
    }

}
