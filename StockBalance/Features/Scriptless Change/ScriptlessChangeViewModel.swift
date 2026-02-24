import Foundation

@MainActor
internal class ScriptlessChangeViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var startMonth = 1
    @Published var endMonth = 1
    
    @Published var startYear = 2026
    @Published var endYear = 2026

    let months = Array(1...12)
    let years = Array(2025...2026)

    let shortMonthSymbols = DateFormatter().shortMonthSymbols ?? []

    private(set) var listStock: [ScriptlessChangeData] = []
    var alertMessage: String = ""
    var startTime: String = ""
    var endTime: String = ""
    
    init() {
        let currentDate = Date()
        let calendar = Calendar.current

        endMonth = calendar.component(.month, from: currentDate) - 1
        endYear = calendar.component(.year, from: currentDate)
        if endMonth == 0 { endMonth = 12; endYear -= 1 }

        startMonth = endMonth - 1
        startYear = endYear
        if startMonth == 0 { startMonth = 12; startYear -= 1 }
    }
    
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
            let (response, _) = try await NetworkManager.shared.request(
                urlString: urlString,
                method: .get,
                responseType: ScriptlessChangeResponse.self
            )
            
            listStock = response.data
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
        let start = String(format: "%d-%02d-01", startYear, startMonth)
        let end   = String(format: "%d-%02d-01", endYear, endMonth)
        return (start, end)
    }
}
