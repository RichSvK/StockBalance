import Foundation

struct ScriptlessChangeResponse: Decodable {
    let message: String
    let data: [ScriptlessChangeData]
}

struct ScriptlessChangeData: Decodable, Hashable {
    let code: String
    let firstShare: UInt64
    let secondShare: UInt64
    let firstListedShares: UInt64
    let secondListedShares: UInt64
    let change: Int64
    let changePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case code
        case firstShare = "first_share"
        case secondShare = "second_share"
        case firstListedShares = "first_listed_share"
        case secondListedShares = "second_listed_share"
        case change
        case changePercentage = "change_percentage"
    }
}
