//
//  InvestorType 2.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 31/12/25.

enum InvestorType: Int, CaseIterable {
    case all = 0
    case domestic = 1
    case foreign = 2
    
    var title: String {
        switch self {
        case .all: return "All"
        case .domestic: return "Domestic"
        case .foreign: return "Foreign"
        }
    }
}
