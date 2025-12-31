//
//  BalanceChangeViewModel.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

import Foundation

@MainActor
internal class BalanceChangeViewModel: ObservableObject {
    // MARK: Published Variables
    @Published var isDecreased: String = "Decrease"
    @Published var holder: ShareholderCategory = .localID
    @Published var showAlert: Bool = false
    @Published var currentPage: Int = 1 {
        didSet {
            Task {
                await loadData(shareholderType: self.holder.rawValue, isDecreased: self.isDecreased)
            }
        }
    }
    @Published var isLoading: Bool = false
    
    // MARK: Public Variables
    var listStock: [BalanceChangeData] = []
    var alertMessage: String = ""
    var statusDecrease: Bool = false
    var haveNext: Bool = false
    
    // Function to load shareholder changes in stock
    func loadData(shareholderType holder: String, isDecreased change: String) async {
        guard TokenManager.shared.accessToken != nil else {
            return
        }
        
        guard var components = URLComponents(string: BalanceChangeEndpoint.getBalance.urlString) else {
            alertMessage = "Invalid endpoint"
            showAlert = true
            return
        }

        components.queryItems = [
            URLQueryItem(name: "type", value: mapToCategory(holder)),
            URLQueryItem(name: "change", value: change),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]

        guard let urlString = components.url?.absoluteString else {
            alertMessage = "Failed to build URL"
            showAlert = true
            return
        }
        
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let (response, _) = try await NetworkManager.shared.request(
                urlString: urlString,
                method: .get,
                responseType: BalanceChangeResponse.self
            )
            
            statusDecrease = isDecreased == "Decrease" ? true : false
            haveNext = response.haveNext
            listStock = response.data ?? []
            
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }
    
    private func mapToCategory(_ text: String) -> String {
        // Normalize the input: lowercase + replace spaces with "_"
        let key = text.lowercased().replacingOccurrences(of: " ", with: "_")
        return key
    }

    // Change page to previous or
    func changePage(isNext next: Bool) {
        currentPage += (next ? 1 : -1)
    }
    
    func convertNumber(of value: Double) -> Double {
        return value * (statusDecrease ? -1 : 1)
    }
    
    func showData() {
        currentPage = 1
    }
}
