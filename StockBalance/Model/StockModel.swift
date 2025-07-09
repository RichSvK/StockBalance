import Foundation

struct StockResponse: Decodable {
    let code: Int
    let message: String
    let data: [StockBalance]
}

struct StockBalance: Decodable {
    let date: Date
    let listedShares: UInt64
    let localIS: UInt64
    let localCP: UInt64
    let localPF: UInt64
    let localIB: UInt64
    let localID: UInt64
    let localMF: UInt64
    let localSC: UInt64
    let localFD: UInt64
    let localOT: UInt64
    
    let foreignIS: UInt64
    let foreignCP: UInt64
    let foreignPF: UInt64
    let foreignIB: UInt64
    let foreignID: UInt64
    let foreignMF: UInt64
    let foreignSC: UInt64
    let foreignFD: UInt64
    let foreignOT: UInt64

    enum CodingKeys: String, CodingKey {
        case date
        case listedShares = "listed_shares"
        case localIS = "local_is"
        case localCP = "local_cp"
        case localPF = "local_pf"
        case localIB = "local_ib"
        case localID = "local_id"
        case localMF = "local_mf"
        case localSC = "local_sc"
        case localFD = "local_fd"
        case localOT = "local_ot"
        case foreignIS = "foreign_is"
        case foreignCP = "foreign_cp"
        case foreignPF = "foreign_pf"
        case foreignIB = "foreign_ib"
        case foreignID = "foreign_id"
        case foreignMF = "foreign_mf"
        case foreignSC = "foreign_sc"
        case foreignFD = "foreign_fd"
        case foreignOT = "foreign_ot"
    }
}

struct StockSeries: Identifiable {
    let id = UUID()
    let date: Date
    let value: UInt64
    let category: String
    let investorType: Int
}
