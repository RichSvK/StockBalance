//
//  Secrets.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 14/12/25.
//

import Foundation

final class Secrets {
    static let shared = Secrets()

    private var secrets: [String: Any] = [:]

    private init() {
        if let path: String = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict: [String: Any] = NSDictionary(contentsOfFile: path) as? [String: Any] {
            secrets = dict
        }
    }

    var backendHost: String? {
        secrets["BACKEND_HOST"] as? String
    }
}
