//
//  WatchListResponse.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import Foundation

struct WatchListResponse: Decodable {
    let message: String
    let stock: [String]?
}
