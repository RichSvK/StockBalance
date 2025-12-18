import Foundation

@MainActor
internal class ScriptlessChangeViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    private(set) var listStock: [ScriptlessChangeData] = []
    var alertMessage: String = ""
    var startTime: String = ""
    var endTime: String = ""

    func fetchChanges() async {
        guard TokenManager.shared.accessToken != nil else {
            alertMessage = NetworkError.notLoggedIn.errorDescription ?? "You are not logged in"
            listStock = []
            showAlert = true
            return
        }
        
        (startTime, endTime) = buildStartEndDates()

        // Build URLComponents safely
        guard var components = URLComponents(string: ScriptlessEndpoint.getScriptlessChange.urlString) else {
            alertMessage = "Invalid endpoint"
            showAlert = true
            return
        }

        components.queryItems = [
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "end_time", value: endTime)
        ]

        guard let urlString = components.url?.absoluteString else {
            alertMessage = "Failed to build URL"
            showAlert = true
            return
        }
        
        // Set state to loading and reset listStock
        listStock = []
        isLoading = true
        
        do {
            let (response, statusCode) = try await NetworkManager.shared.request(
                urlString: urlString,
                method: .get,
                responseType: ScriptlessChangeResponse.self
            )
            
            guard statusCode == 200, let data = response.data else {
                throw NetworkError.invalidResponse
            }
            
            listStock = data

        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
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
