//
//  BalanceChangeViewModel.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

import Foundation

internal class BalanceChangeViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var isDecreased: String = "Decrease"
    @Published var holder: ShareholderCategory = .localID
    @Published var showAlert: Bool = false
    @Published var listStock: [BalanceChangeResponse] = []
    @Published var currentPage: Int = 1
    
    // MARK: Public Variables
    var errorMessage: String = ""
    var statusDecrease: Bool = false
    var haveNext: Bool = false
    
    init() {
        loadData(shareholderType: holder.rawValue, isDecreased: isDecreased)
    }
    
    func loadData(shareholderType holder: String, isDecreased change: String) {
        let url: String = BalanceChangeEndpoint.getBalance(
            shareholderType: mapToCategory(holder),
            change: change,
            page: "\(currentPage)").path
                
        NetworkManager.shared.fetch(from: url, responseType: [BalanceChangeResponse].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200 else {
                        self.errorMessage = "Login Failed"
                        self.showAlert = true
                        return
                    }
                    
                    self.statusDecrease = self.isDecreased == "Decrease" ? true : false
                    self.haveNext = response.count >= 11 ? true : false
                    self.listStock = self.haveNext ? Array(response.dropLast()) : response
                
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    private func mapToCategory(_ text: String) -> String {
        // Normalize the input: lowercase + replace spaces with "_"
        let key = text.lowercased().replacingOccurrences(of: " ", with: "_")
        return key
    }

    func changePage(isNext next: Bool) {
        DispatchQueue.main.async {
            self.currentPage += (next ? 1 : -1)
            self.loadData(shareholderType: self.holder.rawValue, isDecreased: self.isDecreased)
        }
    }
    
    func convertNumber(of value: Double) -> Double {
        return value * (self.statusDecrease ? -1 : 1)
    }
    
    func showData() {
        DispatchQueue.main.async {
            self.currentPage = 1
            self.loadData(shareholderType: self.holder.rawValue, isDecreased: self.isDecreased)
        }
    }
}
