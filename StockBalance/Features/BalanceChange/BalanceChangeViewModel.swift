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
                await loadData(shareholderType: self.holder.rawValue, isDecreased: self.isDecreased)
            }
        }
    }
    @Published var isLoading: Bool = false
    
    // MARK: Public Variables
    var alertMessage: String = ""
    var statusDecrease: Bool = false
    var haveNext: Bool = false
    
    // Function to load shareholder changes in stock
    func loadData(shareholderType holder: String, isDecreased change: String) async {
        guard TokenManager.shared.accessToken != nil else {
            return
        }
        
        guard var components = URLComponents(string: BalanceChangeEndpoint.getBalance.urlString) else {
            self.alertMessage = "Invalid endpoint"
            Task { @MainActor in self.showAlert = true }
            return
        }

        components.queryItems = [
            URLQueryItem(name: "type", value: mapToCategory(holder)),
            URLQueryItem(name: "change", value: change),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]

        guard let urlString = components.url?.absoluteString else {
            self.alertMessage = "Failed to build URL"
            Task { @MainActor in self.showAlert = true }
            return
        }
        
        Task { @MainActor in self.isLoading = true }
        
        Task { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let (response, statusCode) = try await NetworkManager.shared.request(
                    urlString: urlString,
                    method: .get,
                    responseType: BalanceChangeResponse.self
                )
                
                guard statusCode == 200 else {
                    throw NetworkError.unauthorizedError
                }
                
                self.statusDecrease = self.isDecreased == "Decrease" ? true : false
                haveNext = response.haveNext
                listStock = response.data ?? []
                
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
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
