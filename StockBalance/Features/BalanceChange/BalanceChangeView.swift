//
//  BalanceChange.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

import SwiftUI

struct BalanceChangeView: View {
    @StateObject var viewModel: BalanceChangeViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Text("Shareholder Changes")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Shareholder Type")
                    
                    Spacer()
                    
                    Picker("Category", selection: $viewModel.holder) {
                        ForEach(ShareholderCategory.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                HStack {
                    Text("Changes")
                    
                    Spacer()
                    
                    Picker("Changes", selection: $viewModel.isDecreased) {
                        ForEach(["Increase", "Decrease"], id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                StockButton(action: viewModel.showData, label: {
                    Text("Show")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                })
                .padding(.bottom)
                
                Text("Result")
                    .font(.title3)
                
                BalanceChangeResult(viewModel: viewModel)
                
                HStack {
                    StockButton(
                        action: { viewModel.changePage(isNext: false) },
                        background: viewModel.currentPage == 1 ? ColorToken.disabledGreen.toColor() : ColorToken.greenColor.toColor(),
                        label: { Image(systemName: "chevron.left") }
                    )
                    .disabled(viewModel.currentPage == 1)
                    
                    Text("\(viewModel.currentPage)")
                    
                    StockButton(
                        action: { viewModel.changePage(isNext: true) },
                        background: !viewModel.haveNext ? ColorToken.disabledGreen.toColor() : ColorToken.greenColor.toColor(),
                        label: { Image(systemName: "chevron.right") }
                    )
                    .disabled(!viewModel.haveNext)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

private struct BalanceChangeResult: View {
    @ObservedObject var viewModel: BalanceChangeViewModel
    
    var body: some View {
        ForEach(viewModel.listStock.indices, id: \.self) { index in
            let item = viewModel.listStock[index]
            
            HStack {
                Text(item.stockCode)
                Spacer()
                Text("\(formatNumber(viewModel.convertNumber(of: item.changePercentage)))%")
                    .foregroundStyle(item.currentOwnership < item.previousOwnership ? ColorToken.redColor.toColor() : ColorToken.greenColor.toColor())
            }
            .padding(.vertical, 6)
        }
    }
}
