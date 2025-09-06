import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case username
    }
}
