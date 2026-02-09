import SwiftUI

@MainActor
internal class StockBalanceViewModel: ObservableObject {
    // MARK: Models
    struct CategoryMoMDiff: Identifiable {
        let id = UUID()
        let category: String
        let value: Double
    }
    
    private struct BalanceField {
        let key: String
        let keyPath: KeyPath<StockBalance, UInt64>
        let investorType: InvestorType
        let category: InvestorCategory
    }
    
    // MARK: Published variables
    @Published var showAlert: Bool = false
    @Published var investorType: InvestorType = .all {
        didSet {
            filterBalance()
            isLoading = false
        }
    }
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var isUpdating = false

    // MARK: Public Read Only
    private(set) var filteredBalance: [StockSeries] = []
    private(set) var flattenedSeries: [StockSeries] = []
    private(set) var isWatchList = false

    // MARK: Public Variables
    var alertMessage: String = ""
    var stock: String = "BBCA"
    
    // MARK: Internal Data
    private var stockBalance: [StockBalance] = []
    private var emptyCategories: [String] = []
    
    private lazy var balanceFields: [BalanceField] = [
        .init(key: "localIS", keyPath: \.localIS, investorType: .domestic, category: .insurance),
        .init(key: "localCP", keyPath: \.localCP, investorType: .domestic, category: .corporate),
        .init(key: "localPF", keyPath: \.localPF, investorType: .domestic, category: .pensionFund),
        .init(key: "localIB", keyPath: \.localIB, investorType: .domestic, category: .bank),
        .init(key: "localID", keyPath: \.localID, investorType: .domestic, category: .individual),
        .init(key: "localMF", keyPath: \.localMF, investorType: .domestic, category: .mutualFund),
        .init(key: "localSC", keyPath: \.localSC, investorType: .domestic, category: .securities),
        .init(key: "localFD", keyPath: \.localFD, investorType: .domestic, category: .foundation),
        .init(key: "localOT", keyPath: \.localOT, investorType: .domestic, category: .other),

        .init(key: "foreignIS", keyPath: \.foreignIS, investorType: .foreign, category: .insurance),
        .init(key: "foreignCP", keyPath: \.foreignCP, investorType: .foreign, category: .corporate),
        .init(key: "foreignPF", keyPath: \.foreignPF, investorType: .foreign, category: .pensionFund),
        .init(key: "foreignIB", keyPath: \.foreignIB, investorType: .foreign, category: .bank),
        .init(key: "foreignID", keyPath: \.foreignID, investorType: .foreign, category: .individual),
        .init(key: "foreignMF", keyPath: \.foreignMF, investorType: .foreign, category: .mutualFund),
        .init(key: "foreignSC", keyPath: \.foreignSC, investorType: .foreign, category: .securities),
        .init(key: "foreignFD", keyPath: \.foreignFD, investorType: .foreign, category: .foundation),
        .init(key: "foreignOT", keyPath: \.foreignOT, investorType: .foreign, category: .other)
    ]

    private let investorLabelToCategory: [String: String] = [
        "Local IS": "Insurance",
        "Foreign IS": "Insurance",

        "Local CP": "Corporate",
        "Foreign CP": "Corporate",

        "Local PF": "Pension Fund",
        "Foreign PF": "Pension Fund",

        "Local IB": "Bank",
        "Foreign IB": "Bank",

        "Local ID": "Individual",
        "Foreign ID": "Individual",

        "Local MF": "Mutual Fund",
        "Foreign MF": "Mutual Fund",

        "Local SC": "Securities",
        "Foreign SC": "Securities",

        "Local FD": "Foundation",
        "Foreign FD": "Foundation",

        "Local OT": "Other",
        "Foreign OT": "Other"
    ]

    var categoryMonthOverMonthDiff: [CategoryMoMDiff] {
        guard stockBalance.count >= 2 else { return [] }

        let current = stockBalance[0]
        let previous = stockBalance[1]

        let applicableFields = balanceFields.filter {
            investorType == .all || $0.investorType == investorType
        }

        var diffByCategory: [String: Double] = [:]

        for field in applicableFields {
            let currentValue = Double(current[keyPath: field.keyPath])
            let previousValue = Double(previous[keyPath: field.keyPath])

            guard previousValue > 0 else { continue }

            let diff = (currentValue - previousValue) / previousValue * 100
            diffByCategory[field.category.rawValue, default: 0] += diff
        }

        return diffByCategory
            .map { CategoryMoMDiff(category: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }
    
    // MARK: - Init
    init(stock: String, isWatchlist: Bool = false) {
        self.stock = stock
        self.isWatchList = isWatchlist
    }
    
    func fetchStockBalance() async {
        isLoading = true
                
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: BalanceEndpoint.getStockBalance(stock).urlString,
                method: .get,
                responseType: StockResponse.self
            )
            
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
            ("Local IS", \.localIS), ("Local CP", \.localCP), ("Local PF", \.localPF),
            ("Local IB", \.localIB), ("Local ID", \.localID), ("Local MF", \.localMF),
            ("Local SC", \.localSC), ("Local FD", \.localFD), ("Local OT", \.localOT),
            ("Foreign IS", \.foreignIS), ("Foreign CP", \.foreignCP), ("Foreign PF", \.foreignPF),
            ("Foreign IB", \.foreignIB), ("Foreign ID", \.foreignID), ("Foreign MF", \.foreignMF),
            ("Foreign SC", \.foreignSC), ("Foreign FD", \.foreignFD), ("Foreign OT", \.foreignOT)
        ]
        
        return categoryKeyPaths
            .filter { (_, keyPath) in stockBalances.allSatisfy { $0[keyPath: keyPath] == 0 } }
            .map { $0.0 }
    }
    
    private func filterBalance() {
        switch investorType {
        case .all:
            filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0, exclude: emptyCategories, includeSummary: true)
            }
            flattenedSeries = filteredBalance
            
        default:
            filteredBalance = stockBalance.flatMap {
                extractSeries(from: $0, exclude: emptyCategories)
            }
            
            flattenedSeries = filteredBalance.filter { $0.investorType == investorType.rawValue }
        }
    }
    
    private func extractSeries(from item: StockBalance, exclude categoriesToExclude: [String] = [], includeSummary: Bool = false) -> [StockSeries] {
        let rawSeries: [RawSeries] = [
            RawSeries(value: item.localIS, investorType: 1, category: .localIS),
            RawSeries(value: item.localCP, investorType: 1, category: .localCP),
            RawSeries(value: item.localPF, investorType: 1, category: .localPF),
            RawSeries(value: item.localIB, investorType: 1, category: .localIB),
            RawSeries(value: item.localID, investorType: 1, category: .localID),
            RawSeries(value: item.localMF, investorType: 1, category: .localMF),
            RawSeries(value: item.localSC, investorType: 1, category: .localSC),
            RawSeries(value: item.localFD, investorType: 1, category: .localFD),
            RawSeries(value: item.localOT, investorType: 1, category: .localOT),
            
            RawSeries(value: item.foreignIS, investorType: 2, category: .foreignIS),
            RawSeries(value: item.foreignCP, investorType: 2, category: .foreignCP),
            RawSeries(value: item.foreignPF, investorType: 2, category: .foreignPF),
            RawSeries(value: item.foreignIB, investorType: 2, category: .foreignIB),
            RawSeries(value: item.foreignID, investorType: 2, category: .foreignID),
            RawSeries(value: item.foreignMF, investorType: 2, category: .foreignMF),
            RawSeries(value: item.foreignSC, investorType: 2, category: .foreignSC),
            RawSeries(value: item.foreignFD, investorType: 2, category: .foreignFD),
            RawSeries(value: item.foreignOT, investorType: 2, category: .foreignOT  )
        ]
        
        let detailed = rawSeries.compactMap { series -> StockSeries? in
            guard !categoriesToExclude.contains(series.category.rawValue) else { return nil }
            
            return StockSeries(
                date: item.date,
                value: Double(series.value) / Double(item.listedShares) * 100,
                category: investorLabelToCategory[series.category.rawValue] ?? series.category.rawValue,
                investorType: series.investorType
            )
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
    let category: ShareholderCategory
}
