import Foundation

@MainActor
internal class ScriptlessChangeViewModel: ObservableObject {
    @Published private(set) var listStock: [ScriptlessChangeData] = []
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    var alertMessage: String = ""
    var startTime: String = ""
    var endTime: String = ""

    func fetchChanges() async {
        guard TokenManager.shared.accessToken != nil else {
            self.alertMessage = NetworkError.notLoggedIn.errorDescription ?? "You are not logged in"
            Task { @MainActor in
                self.listStock = []
                self.showAlert = true
            }
            return
        }
        
        (startTime, endTime) = buildStartEndDates()

        // Build URLComponents safely
        guard var components = URLComponents(string: ScriptlessEndpoint.getScriptlessChange.urlString) else {
            self.alertMessage = "Invalid endpoint"
            self.showAlert = true
            return
        }

        components.queryItems = [
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "end_time", value: endTime)
        ]

        guard let urlString = components.url?.absoluteString else {
            self.alertMessage = "Failed to build URL"
            self.showAlert = true
            return
        }
        
        // Set state to loading and reset listStock
        Task { @MainActor in
            self.isLoading = true
            self.listStock = []
        }
        
        Task { @MainActor in
            do {
                defer { self.isLoading = false }

                let (response, statusCode) = try await NetworkManager.shared.request(
                    urlString: urlString,
                    method: .get,
                    responseType: ScriptlessChangeResponse.self
                )
                
                guard statusCode == 200, let data = response.data else {
                    self.alertMessage = response.message
                    self.showAlert = true
                    return
                }
                self.listStock = data

            } catch {
                // Error
            }
        }
    }

    /// Function for date strings
    /// - Returns:
    ///   A tuple containing:
    ///   - `startDate`: The start date string (two months before the current month)
    ///   - `endDate`: The end date string (one month before the current month)
    private func buildStartEndDates() -> (String, String) {
        let currentDate = Date()
        let calendar = Calendar.current

        var prevMonth = calendar.component(.month, from: currentDate) - 1
        var prevYear = calendar.component(.year, from: currentDate)
        if prevMonth == 0 { prevMonth = 12; prevYear -= 1 }

        var prevTwoMonth = prevMonth - 1
        var prevTwoYear = prevYear
        if prevTwoMonth == 0 { prevTwoMonth = 12; prevTwoYear -= 1 }

        let start = String(prevTwoYear) + "-" + String(format: "%02d", prevTwoMonth) + "-01"
        let end   = String(prevYear)     + "-" + String(format: "%02d", prevMonth)    + "-01"

        return (start, end)
    }
}
