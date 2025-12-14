//
//  WatchListView.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import SwiftUI

struct WatchlistView: View {
    @StateObject var viewModel: WatchListViewModel
    @State private var navigateToStockBalance = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 12) {
                Text("Stock Watchlist")
                    .font(.title)
                    .fontWeight(.bold)
                
                NavigationLink {
                    SearchView(viewModel: viewModel)
                } label: {
                    TextField("Search stocks", text: .constant(""))
                        .disabled(true)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                if viewModel.watchList.count != 0 {
                    ForEach(viewModel.watchList, id: \.self) { stock in
                        NavigationLink {
                            StockBalanceView(viewModel: StockBalanceViewModel(stock: stock))
                        } label: {
                            watchlistRow(stock)
                        }
                    }
                } else {
                    Text("No Stocks in watchlist")
                        .font(.body)
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func watchlistRow(_ stock: String) -> some View {
        HStack {
            Text(stock)
                .font(.headline)
                .foregroundColor(ColorToken.whiteBlackColor.toColor())

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
