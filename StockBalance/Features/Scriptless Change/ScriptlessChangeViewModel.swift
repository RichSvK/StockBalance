import Foundation

class ScriptlessChangeViewModel: ObservableObject {
    @Published var listStock: [ScriptlessChangeData] = []
    
    var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    func fetchChanges() {
        let currentDate: Date = Date()
        let calendar = Calendar.current
        
        var prevMonth = calendar.component(.month, from: currentDate) - 1
        var prevYear = calendar.component(.year, from: currentDate)
        
        if prevMonth == 0{
            prevMonth = 12
            prevYear = prevYear - 1
        }
        
        var prevTwoMonth = prevMonth - 1
        var prevTwoYear = prevYear
        
        if prevTwoMonth == 0{
            prevTwoMonth = 12
            prevTwoYear = prevTwoYear - 1
        }
        
        let startTime: String = String(prevTwoYear) + "-" + String(format: "%02d", prevTwoMonth) + "-01"
        let endTime: String = String(prevYear) + "-" + String(format: "%02d", prevMonth) + "-01"
        
        let url: String = "http://127.0.0.1:3000/balance/scriptless?start_time=\(startTime)&end_time=\(endTime)"
        print("Test")
        NetworkManager.shared.fetch(from: url, responseType: ScriptlessChangeResponse.self){ result in
            DispatchQueue.main.async{
                switch result {
                    case .success(let response):
                        guard response.code == 200, let data = response.data else {
                            self.alertMessage = response.message
                            self.showAlert = true
                            return
                        }
                        self.listStock = data
                    
                    case .failure(let error):
                        self.alertMessage = "Failed to get data"
                        self.showAlert = true
                        print("Failed to fetch data: \(error)")
                }
            }
        }
    }
}
