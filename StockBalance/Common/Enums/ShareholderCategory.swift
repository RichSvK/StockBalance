//
//  ShareholderCategory.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 15/11/25.
//

enum ShareholderCategory: String, CaseIterable, Identifiable {
    case localIS = "Local IS"
    case localCP = "Local CP"
    case localPF = "Local PF"
    case localIB = "Local IB"
    case localID = "Local ID"
    case localMF = "Local MF"
    case localSC = "Local SC"
    case localFD = "Local FD"
    case localOT = "Local OT"

    case foreignIS = "Foreign IS"
    case foreignCP = "Foreign CP"
    case foreignPF = "Foreign PF"
    case foreignIB = "Foreign IB"
    case foreignID = "Foreign ID"
    case foreignMF = "Foreign MF"
    case foreignSC = "Foreign SC"
    case foreignFD = "Foreign FD"
    case foreignOT = "Foreign OT"

    var id: String { self.rawValue }
}
