import Foundation

/// Singleton of NetworkManager
final class NetworkManager {
    /// The shared instance is a static property of NetworkManager class not instance
    static let shared = NetworkManager()
    
    /// Private initializer to prevent external instantiation
    private init() { }
    
    func request<Response: Decodable>(
        urlString: String,
        method: HTTPMethod,
        body: Encodable? = nil,
        responseType: Response.Type
    ) async throws -> (Response, Int) {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let token = TokenManager.shared.accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decoded = try decoder.decode(Response.self, from: data)
        return (decoded, httpResponse.statusCode)
    }
}
