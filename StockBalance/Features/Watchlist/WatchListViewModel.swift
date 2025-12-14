//
//  WatchListViewModel.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import Foundation

internal class WatchListViewModel: ObservableObject, SearchableViewModel {
    @Published private(set) var watchList: [String] = [
        "SGRO",
        "YOII",
        "GUNA",
        "PMUI",
        "BMRI",
        "ASII"
    ]
    @Published private(set) var showAlert: Bool = false
    private(set) var alertMessage: String = ""
    
    // MARK: SearchableViewModel Protocol Properties
    @Published var searchText: String = ""
    @Published var searchResults: [String] = []
    @Published var isSearching: Bool = false
    
    private var searchTask: Task<Void, Never>?

    // Fetch watchlist data
    func fetchWatchlist() async {
        // Build URLComponents safely
        guard var components = URLComponents(string: WatchListEndpoint.getWatchlist.path) else {
            self.alertMessage = "Invalid endpoint"
            self.showAlert = true
            return
        }

        components.queryItems = [
            URLQueryItem(name: "user_id", value: "")
        ]

        guard let urlString = components.url?.absoluteString else {
            self.alertMessage = "Failed to build URL"
            self.showAlert = true
            return
        }

        NetworkManager.shared.fetch(from: urlString, responseType: WatchListResponse.self) { [weak self] result in
            // Move UI updates back to main actor
            Task { @MainActor in
                guard let self = self else { return }

                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200, let resultData = response.stock else {
                        self.alertMessage = response.message
                        self.showAlert = true
                        return
                    }
                    self.watchList = resultData

                case .failure(let error):
                    self.alertMessage = "Failed to get data: \(error.localizedDescription)"
                    self.showAlert = true
                    print("Network error:", error)
                }
            }
        }
    }
    
    // Search stock
    func searchStocks() {
        // Cancel previous debounce + request
        searchTask?.cancel()

        let stock = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !stock.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }

        searchTask = Task { @MainActor in
            // Debounce
            try? await Task.sleep(nanoseconds: 400_000_000)

            guard !Task.isCancelled else { return }

            guard var components = URLComponents(
                string: WatchListEndpoint.getStock.urlString
            ) else {
                alertMessage = "Invalid endpoint"
                showAlert = true
                return
            }

            components.queryItems = [
                URLQueryItem(name: "code", value: stock)
            ]

            guard let urlString = components.url?.absoluteString else {
                alertMessage = "Failed to build URL"
                showAlert = true
                return
            }

            isSearching = true
            
            defer { isSearching = false }

            await fetchStocks(urlString: urlString)
        }
    }
    
    // Fetch Stocks
    private func fetchStocks(urlString: String) async {
        await withCheckedContinuation { continuation in
            NetworkManager.shared.fetch(from: urlString, responseType: StockSearchResponse.self) { [weak self] result in
                guard let self = self else {
                    continuation.resume()
                    return
                }
                
                Task { @MainActor in
                    switch result {
                    case .success(let (response, statusCode)):
                        guard statusCode == 200, let data = response.data else {
                            self.showAlert = true
                            continuation.resume()
                            return
                        }
                        self.searchResults = data

                    case .failure(let error):
                        self.alertMessage = "Failed to get data: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }

                continuation.resume()
            }
        }
    }
}
