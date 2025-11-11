import Charts
import SwiftUI

struct StockBalanceView: View {
    @StateObject var viewModel: StockBalanceViewModel
    
    enum Field {
        case name
    }
    
    @FocusState var isFocused: Field?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                Text("Stock Balance")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Stock Code", text: $viewModel.stock)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused, equals: .name)
                    .onSubmit {
                        viewModel.fetchStockBalance()
                    }
                
                Text("\(viewModel.stock) Shareholder Composition")
                    .font(.headline)
                    .padding(.horizontal)
                
                Picker("Chart Type", selection: $viewModel.investorType) {
                    Text("All").tag("All")
                    Text("Domestic").tag("Domestic")
                    Text("Foreign").tag("Foreign")
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)
                
                if viewModel.flattenedSeries.isEmpty {
                    Text("No data available")
                        .foregroundColor(.secondary)
                        .frame(height: 400)
                } else {
                    StockChart(series: viewModel.flattenedSeries)
                }
            }
            .padding()
        }
        .onTapGesture {
            isFocused = nil
        }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
