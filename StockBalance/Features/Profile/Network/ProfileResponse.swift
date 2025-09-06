import Foundation

struct ProfileResponse: Decodable {
    let message: String
    let time: String
    let data: Profile?
}

struct Profile: Decodable {
    let username: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
    }
}
