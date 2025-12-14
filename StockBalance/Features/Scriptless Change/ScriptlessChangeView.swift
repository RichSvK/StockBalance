import SwiftUI

struct ScriptlessChangeView: View {
    @StateObject var viewModel: ScriptlessChangeViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                headerSection
                separator

                contentSection
            }
            .padding(.horizontal)
        }
        .task { await viewModel.fetchChanges() }
        .alert("Notice", isPresented: $viewModel.showAlert) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .padding(.horizontal)
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Scriptless Change")
                .font(.title)
                .fontWeight(.bold)

            headerRow
        }
        .padding(.vertical, 8)
    }
    
    var headerRow: some View {
        HStack {
            Text("Stock")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            Text("Change (%)")
                .font(.title3)
                .frame(width: 110, alignment: .trailing)
        }
        .padding(.horizontal, 4)
        .padding(.top, 12)
    }
    
    private func scriptlessDataRow(stock: String, change: Double) -> some View {
        HStack(spacing: 12) {
            Text(stock)
                .font(.callout)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // show percentage with 2 decimal places
            Text("\(formatNumber(change))%")
                .font(.callout)
                .frame(width: 110, alignment: .trailing)
                .foregroundStyle(colorForChange(change))
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .semibold))
        }
    }

    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            loadingView
        } else {
            stockList
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading data")
                .font(.subheadline)
        }
        .frame(height: 300)
    }

    private var stockList: some View {
        ForEach(viewModel.listStock, id: \.self) { item in
            VStack(spacing: 12) {
                stockRow(item)
            }
        }
    }
    
    private func stockRow(_ item: ScriptlessChangeData) -> some View {
        NavigationLink {
            ScriptlessChangeDetailView(
                stock: item,
                startTime: viewModel.startTime,
                endTime: viewModel.endTime
            )
        } label: {
            scriptlessDataRow(
                stock: item.code,
                change: item.changePercentage
            )
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
    }

    private var separator: some View {
        Rectangle()
            .frame(height: 0.6)
            .foregroundColor(Color(.separator))
            .opacity(0.6)
    }

    // Small helper for color
    private func colorForChange(_ change: Double) -> Color {
        if change > 0 { return ColorToken.greenColor.toColor() }
        if change < 0 { return ColorToken.redColor.toColor() }
        return .yellow
    }
}
