//
//  DateFormatter.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 06/12/25.
//

import Foundation

/// Date formatting helpers used across the app.
enum DateMonthFormatter {

    /// Converts a `yyyy-MM-dd` date string into a month name.
    ///
    /// - Parameter dateString: Date string in `yyyy-MM-dd` format
    /// - Returns: Localized month name (e.g. "October"), or "-" on failure
    static func monthName(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM"
        outputFormatter.locale = Locale.current

        guard let date = inputFormatter.date(from: dateString) else {
            return "-"
        }

        return outputFormatter.string(from: date)
    }

    /// Converts a `yyyy-MM-dd` date string into `"Month Name"` format.
    ///
    /// - Parameter dateString: Date string in `yyyy-MM-dd` format
    /// - Returns: Formatted month label, or "-" on failure
    static func monthNumberAndName(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return "-"
        }

        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"

        let monthName = nameFormatter.string(from: date)
        return "\(monthName)"
    }
}
