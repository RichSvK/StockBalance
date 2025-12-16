//
//  BalanceChangeEndpoint.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

enum BalanceChangeEndpoint: EndpointProtocol {
    case getBalance
    
    var path: String {
        switch self {
        case .getBalance:
            return "/api/auth/balance/change"
        }
    }
}
