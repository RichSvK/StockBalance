import Foundation

struct RegisterResponse: Decodable {
    let message: String
    let time: String
    let data: String?
}
