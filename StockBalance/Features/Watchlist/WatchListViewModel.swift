//
//  WatchListViewModel.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import Foundation

internal class WatchListViewModel: ObservableObject {
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
}
