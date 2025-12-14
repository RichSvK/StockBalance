//
//  SearchView.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 13/12/25.
//

import SwiftUI

protocol SearchableViewModel: ObservableObject {
    var searchText: String { get set }
    var searchResults: [String] { get }
    var isSearching: Bool { get }
    
    func searchStocks()
}

struct SearchView<ViewModel: SearchableViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 12) {

            TextField("Search stocks...", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchStocks()
                }
                .padding(.horizontal)

            if viewModel.isSearching {
                ProgressView("Searching...")
            } else if viewModel.searchResults.isEmpty {
                Text(viewModel.searchText.isEmpty
                     ? "Type to search stocks"
                     : "No results for \"\(viewModel.searchText)\"")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    Section(header: Text("Results")) {
                        ForEach(viewModel.searchResults, id: \.self) { item in
                            NavigationLink {
                                StockBalanceView(
                                    viewModel: StockBalanceViewModel(stock: item)
                                )
                            } label: {
                                Text(item)
                                    .font(.headline)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            Spacer()
        }
        .navigationTitle("Search Stocks")
    }
}
