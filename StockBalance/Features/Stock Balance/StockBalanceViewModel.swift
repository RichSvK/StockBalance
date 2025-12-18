import SwiftUI

@MainActor
internal class StockBalanceViewModel: ObservableObject {
    // MARK: Published variables
    private(set) var filteredBalance: [StockSeries] = []
    @Published var showAlert: Bool = false
    @Published var investorType: String = "All" {
        didSet {
            filterBalance()
            
            Task { @MainActor in
                self.isLoading = false
            }
        }
    }
    @Published private(set) var isLoading: Bool = true
    
    // MARK: Public Variable
    var flattenedSeries: [StockSeries] = []
    var alertMessage: String = ""
    var stock: String = "BBCA"
    
    private var stockBalance: [StockBalance] = []
    private var emptyCategories: [String] = []
    private lazy var propertyToCategory: [String: String] = [
        "localIS": "Insurance",
        "localCP": "Corporate",
        "localPF": "Pension Fund",
        "localIB": "Bank",
        "localID": "Individual",
        "localMF": "Mutual Fund",
        "localSC": "Securities",
        "localFD": "Foundation",
        "localOT": "Other",
        
        "foreignIS": "Insurance",
        "foreignCP": "Corporate",
        "foreignPF": "Pension Fund",
        "foreignIB": "Bank",
        "foreignID": "Individual",
        "foreignMF": "Mutual Fund",
        "foreignSC": "Securities",
        "foreignFD": "Foundation",
        "foreignOT": "Other"
    ]
    
    // MARK: - Init
    init(stock: String, isWatchlist: Bool = false) {
        self.stock = stock
        self.isWatchList = isWatchlist
    }
    
    func fetchStockBalance() async {
        isLoading = true
        
        let url = "\(BalanceEndpoint.getStockBalance.urlString)/\(stock)"
        
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: url,
                method: .get,
                responseType: StockResponse.self)
            
            guard statusCode == 200 else {
                throw NetworkError.server(message: response.message)
            }

            stockBalance = response.data
            emptyCategories = findEmptyCategories(in: stockBalance)
            filterBalance()
        } catch {
            // Error
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }
    
    func findEmptyCategories(in stockBalances: [StockBalance]) -> [String] {
        let categoryKeyPaths: [(String, KeyPath<StockBalance, UInt64>)] = [
            ("localIS", \.localIS), ("localCP", \.localCP), ("localPF", \.localPF),
            ("localIB", \.localIB), ("localID", \.localID), ("localMF", \.localMF),
            ("localSC", \.localSC), ("localFD", \.localFD), ("localOT", \.localOT),
            ("foreignIS", \.foreignIS), ("foreignCP", \.foreignCP), ("foreignPF", \.foreignPF),
            ("foreignIB", \.foreignIB), ("foreignID", \.foreignID), ("foreignMF", \.foreignMF),
            ("foreignSC", \.foreignSC), ("foreignFD", \.foreignFD), ("foreignOT", \.foreignOT)
        ]
        
        return categoryKeyPaths
            .filter { (_, keyPath) in stockBalances.allSatisfy { $0[keyPath: keyPath] == 0 } }
            .map { $0.0 }
    }
    
    private func filterBalance() {
        switch investorType {
        case "All":
            filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0, exclude: emptyCategories, includeSummary: true)
            }
            flattenedSeries = filteredBalance
            
        default:
            filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0, exclude: emptyCategories)
            }
            
            flattenedSeries = filteredBalance.filter {$0.investorType == (investorType == "Domestic" ? 1 : 2)}
        }
    }
    
    private func extractSeries(from item: StockBalance, exclude categoriesToExclude: [String] = [], includeSummary: Bool = false) -> [StockSeries] {
        let rawSeries: [RawSeries] = [
            RawSeries(value: item.localIS, investorType: 1, category: "localIS"),
            RawSeries(value: item.localCP, investorType: 1, category: "localCP"),
            RawSeries(value: item.localPF, investorType: 1, category: "localPF"),
            RawSeries(value: item.localIB, investorType: 1, category: "localIB"),
            RawSeries(value: item.localID, investorType: 1, category: "localID"),
            RawSeries(value: item.localMF, investorType: 1, category: "localMF"),
            RawSeries(value: item.localSC, investorType: 1, category: "localSC"),
            RawSeries(value: item.localFD, investorType: 1, category: "localFD"),
            RawSeries(value: item.localOT, investorType: 1, category: "localOT"),
            
            RawSeries(value: item.foreignIS, investorType: 2, category: "foreignIS"),
            RawSeries(value: item.foreignCP, investorType: 2, category: "foreignCP"),
            RawSeries(value: item.foreignPF, investorType: 2, category: "foreignPF"),
            RawSeries(value: item.foreignIB, investorType: 2, category: "foreignIB"),
            RawSeries(value: item.foreignID, investorType: 2, category: "foreignID"),
            RawSeries(value: item.foreignMF, investorType: 2, category: "foreignMF"),
            RawSeries(value: item.foreignSC, investorType: 2, category: "foreignSC"),
            RawSeries(value: item.foreignFD, investorType: 2, category: "foreignFD"),
            RawSeries(value: item.foreignOT, investorType: 2, category: "foreignOT")
        ]
        
        let detailed = rawSeries.compactMap { series -> StockSeries? in
            guard !categoriesToExclude.contains(series.category) else { return nil }
            
            return StockSeries(date: item.date, value: Double(series.value) / Double(item.listedShares) * 100,
                               category: propertyToCategory[series.category] ?? "", investorType: series.investorType)
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
    
    // MARK: Watchlist
    private(set) var isWatchList = false
    @Published private(set) var isUpdating = false
    
    // Function to update watchlist
    func updateWatchlist() {
        guard TokenManager.shared.accessToken != nil else {
            alertMessage = NetworkError.notLoggedIn.errorDescription ?? "You are not logged in"
            showAlert = true
            return
        }
        
        guard !isUpdating else { return }
        
        isUpdating = true

        Task {
            do {
                if isWatchList {
                    try await removeWatchlist()
                } else {
                    try await addWatchlist()
                }
                
                isWatchList.toggle()
            } catch {
                // Error
            }
            
            showAlert = true
            isUpdating = false
        }
    }
    
    private func addWatchlist() async throws {
        let requestBody = WatchlistRequest(stock: stock)
        
        let (response, statusCode) = try await NetworkManager.shared.request(
            urlString: BalanceEndpoint.addWatchlist.urlString,
            method: .post,
            body: requestBody,
            responseType: WatchlistResponse.self
        )
        
        alertMessage = response.message
        guard statusCode == 201 else { throw URLError(.badServerResponse) }
    }
    
    private func removeWatchlist() async throws {
        let (response, statusCode) = try await NetworkManager.shared.request(
            urlString: BalanceEndpoint.removeWatchlist(stock).urlString,
            method: .delete,
            responseType: WatchlistResponse.self
        )
        
        alertMessage = response.message
        
        guard statusCode == 200 || statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}

// MARK: - Supporting Structs
private struct RawSeries {
    let value: UInt64
    let investorType: Int
    let category: String
}
