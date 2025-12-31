import Foundation

struct ProfileResponse: Decodable {
    let username: String
    let email: String
}

struct Profile: Decodable {
    let username: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
    }
}
