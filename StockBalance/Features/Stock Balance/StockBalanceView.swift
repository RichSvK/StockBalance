import Charts
import SwiftUI

struct StockBalanceView: View {
    @StateObject var viewModel: StockBalanceViewModel
    
    enum Field {
        case name
        case ipAddress
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
                
        
                /// For local use only: insert the IP address and port of the device running the backend.
                HStack {
                    TextField("ex: 192.168.1.100:8080", text: $viewModel.ip)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused, equals: .ipAddress)
                    
                    Button(action: {
                        viewModel.fetchStockBalance()
                        isFocused = nil
                    }){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color("ColorSearchButton"))
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 16)
                
                Text("Shareholder Composition")
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
                } else{
                    Chart {
                        ForEach(viewModel.flattenedSeries) { item in
                            LineMark(
                                x: .value("Date", item.date),
                                y: .value("Value", item.value),
                                series: .value("Category", item.category)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(by: .value("Category", item.category))
                        }
                    }
                    .frame(height: 400)
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel() {
                                if let doubleValue = value.as(Double.self) {
                                    Text(String(format: "%.0f%%", doubleValue))
                                }
                            }
                        }
                    }
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
