//
//  TokenManager.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/12/25.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    private init() {}

    private let tokenKey = "token"

    var accessToken: String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    func save(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
