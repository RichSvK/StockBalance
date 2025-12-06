import SwiftUI

struct ScriptlessChangeDetailView: View {
    let stock: ScriptlessChangeData
    var firstMonth: String
    var secondMonth: String
    
    init(stock: ScriptlessChangeData, startTime: String, endTime: String) {
        self.stock = stock
        firstMonth = DateMonthFormatter.monthNumberAndName(from: startTime)
        secondMonth = DateMonthFormatter.monthNumberAndName(from: endTime)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                statsGrid
                changeSection
                Spacer()
            }
            .padding()
        }
        .navigationTitle(stock.code)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.12))
                .frame(width: 64, height: 64)
                .overlay(Text(String(stock.code.prefix(1))).font(.title).bold().foregroundColor(.primary))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(stock.code)
                    .font(.title2)
                    .bold()
                
                Text("Change: \(formatNumber(stock.changePercentage))%")
                    .font(.subheadline)
                    .foregroundColor(stock.change >= 0 ? .green : .red)
            }
            Spacer()
        }
    }
    
    private var statsGrid: some View {
        VStack(spacing: 8) {
            HStack {
                statCard(title: "\(firstMonth) Scriptless", value: formatNumber(Double(stock.firstShare)))
                statCard(title: "\(firstMonth) Listed", value: formatNumber(Double(stock.firstListedShares)))
            }
            
            HStack {
                statCard(title: "\(secondMonth) Scriptless", value: formatNumber(Double(stock.secondShare)))
                statCard(title: "\(secondMonth) Listed", value: formatNumber(Double(stock.secondListedShares)))
            }
        }
    }
    
    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2))
    }
    
    private var changeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.headline)
            
            HStack {
                Text("Change")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formatNumber(Double(stock.change)))
                    .foregroundColor(stock.change < 0 ? ColorToken.redColor.toColor() : ColorToken.greenColor.toColor())
            }
            
            HStack {
                Text("Change (%)")
                    .foregroundColor(.secondary)
                Spacer()
                
                Text("\(formatNumber(stock.changePercentage))%")
                    .foregroundColor(stock.changePercentage < 0 ? ColorToken.redColor.toColor() : ColorToken.greenColor.toColor())

            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
    }
    
    // Use your own formatter function (keeps consistent display)
    private func formatNumber(_ value: Double?) -> String {
        guard let value = value else { return "-" }
        
        return value.formatted(.number.precision(.fractionLength(0...2)))
    }
}
