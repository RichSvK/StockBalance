import SwiftUI

struct ScriptlessChangeView: View {
    @StateObject var viewModel: ScriptlessChangeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                
                Button(action:{
                    viewModel.fetchChanges()
                }, label:{
                    Text("Fetch Data")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                })
                HeaderRow()
                ForEach(viewModel.listStock, id: \.self) { item in
                    NavigationLink(destination: ScriptlessChangeDetailView(stock: item)) {
                        ScriptlessDataRow(stock: item.code, change: item.changePercentage)
                    }
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
                .font(.title3)
                .frame(width: UIScreen.main.bounds.width * 0.25)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 1)
                .padding(.horizontal, 8)
            
            Text("%")
                .font(.title3)
                .frame(width: UIScreen.main.bounds.width * 0.25)
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .cornerRadius(10)
    }
    
    func ScriptlessDataRow(stock: String, change: Double) -> some View {
        HStack {
            Text(stock)
                .frame(width: UIScreen.main.bounds.width * 0.25)
            
            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(width: 1)
                .padding(.horizontal, 8)
            
            Text("\(formatNumber(change))%")
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
