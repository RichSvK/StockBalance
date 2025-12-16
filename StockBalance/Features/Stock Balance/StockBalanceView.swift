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
                Text("\(viewModel.stock) Shareholder Composition")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Picker("Chart Type", selection: $viewModel.investorType) {
                    Text("All").tag("All")
                    Text("Domestic").tag("Domestic")
                    Text("Foreign").tag("Foreign")
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(height: 400)
                } else if viewModel.flattenedSeries.isEmpty {
                    Text("No data available")
                        .foregroundColor(.secondary)
                        .frame(height: 400)
                } else {
                    StockChart(series: viewModel.flattenedSeries)
                }
            }
            .padding()
        }
        .task {
            await viewModel.fetchStockBalance()
        }
        .onTapGesture { isFocused = nil }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.updateWatchlist()
                }, label: {
                    Image(systemName: viewModel.isWatchList ? "star.fill" : "star")
                        .foregroundColor(viewModel.isWatchList ? .yellow : ColorToken.greenColor.toColor())
                })
                .disabled(viewModel.isUpdating)
            }
        }
    }
}
