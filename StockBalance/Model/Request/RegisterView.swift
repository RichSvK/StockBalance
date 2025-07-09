import Foundation

struct RegisterRequest: Encodable{
    let email: String
    let password: String
    let username: String
    
    init(email: String, password: String, username: String) {
        self.email = email
        self.password = password
        self.username = username
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case username
    }
}
