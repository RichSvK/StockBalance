//
//  BalanceChangeEndpoint.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

enum BalanceChangeEndpoint {
    case getBalance(shareholderType: String, change: String, page: String)
    
    var path: String {
        switch self {
        case .getBalance(let shareholderType, let change, let page):
            return "http://localhost:8080/api/balance/change?type=\(shareholderType)&change=\(change)&page=\(page)"
        }
    }
}
