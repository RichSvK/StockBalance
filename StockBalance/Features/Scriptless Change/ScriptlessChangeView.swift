import SwiftUI

struct ScriptlessChangeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: ScriptlessChangeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                Text("Scriptless Change")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HeaderRow()
                
                Rectangle()
                    .frame(height: 1.2)
                    .foregroundStyle(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.5))
                    .padding(.horizontal, 8)
                
                ForEach(viewModel.listStock, id: \.self) { item in
                    NavigationLink(destination: ScriptlessChangeDetailView(stock: item)) {
                        ScriptlessDataRow(stock: item.code, change: item.changePercentage)
                    }
                    
                    
                    Rectangle()
                        .frame(height: 0.8)
                        .foregroundStyle(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.5))
                        .padding(.horizontal, 8)
                }
            }
        }
        .onAppear {
            viewModel.fetchChanges()
        }
        .alert("Notice", isPresented: $viewModel.showAlert){
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .padding()
    }
    
    private func HeaderRow() -> some View {
        HStack {
            Text("Stock")
                .font(.body)
                .frame(width: UIScreen.main.bounds.width * 0.2)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 1)
                .padding(.horizontal, 8)
            
            Text("Change (%)")
                .font(.body)
                .frame(width: UIScreen.main.bounds.width * 0.3)
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .cornerRadius(10)
    }
    
    func ScriptlessDataRow(stock: String, change: Double) -> some View {
        HStack {
            Text(stock)
                .font(.callout)
                .frame(width: UIScreen.main.bounds.width * 0.25)
            
            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(width: 1)
                .padding(.horizontal, 8)
            
            Text("\(formatNumber(change))%")
                .font(.callout)
                .frame(width: UIScreen.main.bounds.width * 0.25)
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.black)
        .foregroundStyle(change > 0 ? Color.green : change < 0 ? Color.red : Color.yellow)
        .cornerRadius(10)
    }
}
