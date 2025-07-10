import SwiftUI

struct ScriptlessChangeDetailView: View{
    @StateObject var viewModel: ScriptlessChangeViewModel = ScriptlessChangeViewModel()
    
    var stock: ScriptlessChangeData
    
    var body: some View{
        VStack{
            Text(stock.code)
                .font(.headline)
            
            Text(formatNumber(Double(stock.firstShare)))
            Text(formatNumber(Double(stock.firstListedShares)))
            
            Text("First Share\t:\t\(formatNumber(Double(stock.firstShare)))")
            Text("First Listed Shares\t:\t\(formatNumber(Double(stock.firstListedShares)))")
            
            Text("Second Share\t:\t\(formatNumber(Double(stock.secondShare)))")
            Text("Second Listed Shares\t:\t\(formatNumber(Double(stock.secondListedShares)))")
            
            Text("Change\t:\t\(formatNumber(Double(stock.change)))")
            Text("Change (%)\t:\t\(formatNumber(stock.changePercentage))%")
        }
    }
}
