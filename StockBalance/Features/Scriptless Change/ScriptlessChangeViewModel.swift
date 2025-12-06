import Foundation

@MainActor
internal class ScriptlessChangeViewModel: ObservableObject {
    @Published private(set) var listStock: [ScriptlessChangeData] = []
    @Published var showAlert: Bool = false
    var alertMessage: String = ""
    var startTime: String = ""
    var endTime: String = ""

    func fetchChanges() async {
        (startTime, endTime) = buildStartEndDates()

        // Build URLComponents safely
        guard var components = URLComponents(string: ScriptlessEndpoint.getScriptlessChange.path) else {
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

        NetworkManager.shared.fetch(from: urlString, responseType: ScriptlessChangeResponse.self) { [weak self] result in
            // Move UI updates back to main actor
            Task { @MainActor in
                guard let self = self else { return }

                switch result {
                case .success(let (response, statusCode)):
                    guard statusCode == 200, let data = response.data else {
                        self.alertMessage = response.message
                        self.showAlert = true
                        return
                    }
                    self.listStock = data

                case .failure(let error):
                    self.alertMessage = "Failed to get data: \(error.localizedDescription)"
                    self.showAlert = true
                    print("Network error:", error)
                }
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
