//
//  BalanceChangeResponse.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

struct BalanceChangeResponse: Decodable {
    let stockCode: String
    let previousOwnership: Int64
    let currentOwnership: Int64
    let changePercentage: Double

    enum CodingKeys: String, CodingKey {
        case stockCode = "stock_code"
        case previousOwnership = "previous_ownership"
        case currentOwnership = "current_ownership"
        case changePercentage = "change_percentage"
    }
}
