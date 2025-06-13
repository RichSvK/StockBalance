import Foundation

/// Singleton of NetworkManager
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    /// Perform a GET request to a given URL and decode the response into the specified Codable type.
    func fetch<T: Decodable>(from urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let decodedResponse = try decoder.decode(T.self, from: data)
                print("Success")
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
                print("Failure: \(error.localizedDescription)")
            }
        }

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
}
