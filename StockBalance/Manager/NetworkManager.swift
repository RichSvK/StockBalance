import SwiftUI
//import Foundation

/// Singleton of NetworkManager
final class NetworkManager {
    /// The shared instance is a static property of NetworkManager class not instance
    static let shared = NetworkManager()
    
    /// Private initializer to prevent external instantiation
    private init(session: SessionManager = SessionManager.shared) {
        self.session = session
    }
    
    private let session: SessionManager
        
    /// Perform a GET request to a given URL and decode the response into the specified Codable type.
    func fetch<T: Decodable>(from urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(self.session.token)", forHTTPHeaderField: "Authorization")
        /// Sends the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            /// Handles any request error
            if let error = error {
                completion(.failure(error))
                return
            }

            /// Validates that response data exists
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            /// Attempts to decode the JSON response
            do {
                let decoder = JSONDecoder()
                
                /// Decodes date fields using ISO 8601 format like "2024-06-24T15:00:00Z"
                decoder.dateDecodingStrategy = .iso8601

                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
                print("Success")
            } catch {
                completion(.failure(error))
                print("Failure: \(error.localizedDescription)")
            }
        }
        
        /// Starts the data task
        task.resume()
    }

    /// Perform a POST request with an Encodable body.
    func post<T: Decodable, U: Encodable>(to urlString: String, body: U, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(self.session.token)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func setToken(_ token: String) {
        self.session.token = token
    }
}
