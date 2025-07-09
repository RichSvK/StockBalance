import Foundation

struct LoginResponse: Decodable {
    let message: String
    let time: String
    let data: LoginData?
}

struct LoginData: Decodable {
    let token: String
}
