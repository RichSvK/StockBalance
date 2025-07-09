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
                HStack {
                    TextField("Stock Code", text: $viewModel.stock)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused, equals: .name)
                    
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
                .padding(.horizontal)
        
                /// For local use only: insert the IP address and port of the device running the backend.
                HStack {
                    TextField("ex: 192.168.1.100:8080", text: $viewModel.ip)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused, equals: .ipAddress)
                    
                    Button(action: {
                        viewModel.fetchStockBalance()
                    }){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color("ColorSearchButton"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Picker("Chart Type", selection: $viewModel.investorType) {
                    Text("All").tag("All")
                    Text("Domestic").tag("Domestic")
                    Text("Foreign").tag("Foreign")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Picker("Chart Type", selection: $viewModel.chartType) {
                    Text("Line").tag("Line")
                    Text("Bar").tag("Bar")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if viewModel.flattenedSeries.isEmpty {
                    Text("No data available")
                        .foregroundColor(.secondary)
                        .frame(height: 400)
                } else{
                    Chart {
                        if viewModel.chartType == "Line" {
                            ForEach(viewModel.flattenedSeries) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Value", item.value),
                                    series: .value("Category", item.category)
                                )
                                .interpolationMethod(.monotone)
                                .foregroundStyle(by: .value("Category", item.category))
                            }
                        } else if viewModel.chartType == "Bar" {
                            ForEach(viewModel.flattenedSeries) { item in
                                BarMark(
                                    x: .value("Date", item.date),
                                    y: .value("Value", item.value)
                                )
                                .foregroundStyle(by: .value("Holding Category", item.category))
                            }
                        }
                    }
                    .frame(height: 400)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
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
