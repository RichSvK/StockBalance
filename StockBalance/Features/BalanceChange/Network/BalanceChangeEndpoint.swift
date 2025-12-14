//
//  BalanceChangeEndpoint.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

enum BalanceChangeEndpoint: EndpointProtocol {
    case getBalance(shareholderType: String, change: String, page: String)
    
    var path: String {
        switch self {
        case .getBalance(let shareholderType, let change, let page):
            return "/api/balance/change?type=\(shareholderType)&change=\(change)&page=\(page)"
        }
    }
}
