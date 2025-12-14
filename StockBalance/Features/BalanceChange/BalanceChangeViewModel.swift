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
    @Published var listStock: [BalanceChangeData] = []
    @Published var currentPage: Int = 1 {
        didSet {
            Task {
                await self.loadData(shareholderType: self.holder.rawValue, isDecreased: self.isDecreased)
            }
        }
    }
    @Published var isLoading: Bool = true
    
    // MARK: Public Variables
    var errorMessage: String = ""
    var statusDecrease: Bool = false
    var haveNext: Bool = false
    
    func loadData(shareholderType holder: String, isDecreased change: String) async {
        let url: String = BalanceChangeEndpoint.getBalance(
            shareholderType: mapToCategory(holder),
            change: change,
            page: "\(currentPage)").urlString
            
        Task { @MainActor in
            self.isLoading = true
        }
        
        NetworkManager.shared.fetch(from: url, responseType: BalanceChangeResponse.self) { result in
            Task { @MainActor in
                defer { self.isLoading = false }
                
                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200 else {
                        self.errorMessage = "Login Failed"
                        self.showAlert = true
                        return
                    }
                    
                    self.statusDecrease = self.isDecreased == "Decrease" ? true : false
                    self.haveNext = response.haveNext
                    self.listStock = response.data ?? []
                
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                }
                
                self.isLoading = false
            }
        }
    }
    
    private func mapToCategory(_ text: String) -> String {
        // Normalize the input: lowercase + replace spaces with "_"
        let key = text.lowercased().replacingOccurrences(of: " ", with: "_")
        return key
    }

    // Change page to previous or
    func changePage(isNext next: Bool) {
        Task { @MainActor in
            self.currentPage += (next ? 1 : -1)
        }
    }
    
    func convertNumber(of value: Double) -> Double {
        return value * (self.statusDecrease ? -1 : 1)
    }
    
    func showData() {
        Task { @MainActor in
            self.currentPage = 1
        }
    }
}
