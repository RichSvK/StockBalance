//
//  WatchListViewModel.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import Foundation

internal class WatchListViewModel: ObservableObject, SearchableViewModel {
    private(set) var watchList: [String] = [
        "SGRO",
        "YOII",
        "GUNA",
        "PMUI",
        "BMRI",
        "ASII"
    ]
    private(set) var searchResults: [String] = []
    private(set) var alertMessage: String = ""

    @Published private(set) var showAlert: Bool = false
    
    // MARK: SearchableViewModel Protocol Properties
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var isLoading: Bool = false
    
    private var searchTask: Task<Void, Never>?

    // Fetch watchlist data
    func fetchWatchlist() async {
        await MainActor.run {
            watchList = []
            isLoading = true
        }
        
        guard TokenManager.shared.accessToken != nil else {
            await MainActor.run {
                isLoading = false
            }
            return
        }
        
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: WatchListEndpoint.getWatchlist.urlString,
                method: .get,
                responseType: WatchListResponse.self
            )
            
            try await MainActor.run {
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
        
                watchList = response.stocks ?? []
            }
        } catch {
            // Error
            await MainActor.run {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
        
        await MainActor.run {
            isLoading = false
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
            
            do {
                try await fetchStocks(urlString: urlString)
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    // Fetch Stocks
    private func fetchStocks(urlString: String) async throws {
        let (response, statusCode) = try await NetworkManager.shared.request(
            urlString: urlString,
            method: .get,
            responseType: StockSearchResponse.self
        )

        try await MainActor.run {
            guard statusCode == 200, let data = response.data else {
                showAlert = true
                throw URLError(.badServerResponse)
            }

            searchResults = data
        }
    }
}
