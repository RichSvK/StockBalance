import Foundation

struct LoginRequest: Encodable{
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
