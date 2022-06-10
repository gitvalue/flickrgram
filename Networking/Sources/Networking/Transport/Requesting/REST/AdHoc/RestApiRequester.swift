import Foundation

/// REST API endpoint communicator
final class RestApiRequester: Requesting {
    private let apiUrl: String
    private let encoder: Encoding
    private let decoder: Decoding
    private let method: HttpMethod
    private let header: [String: String]
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    /// The designated initializer
    /// - Parameters:
    ///   - apiUrl: REST API endpoint URL
    ///   - encoder: Request serializer
    ///   - decoder: Response deserializer
    ///   - method: HTTP method used for requests
    ///   - header: Fields of the HTTP-request header
    init(apiUrl: String, encoder: Encoding, decoder: Decoding, method: HttpMethod, header: [String: String]) {
        self.apiUrl = apiUrl
        self.encoder = encoder
        self.decoder = decoder
        self.method = method
        self.header = header
    }

    func make<T>(
        request: T,
        _ completion: @escaping (Result<T.Response, Error>) -> ()
    ) where T: Request {
        guard
            let query = (apiUrl + "/" + request.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: query)
        else {
            completion(.failure(UrlError.badUrl))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try? encoder.encode(request.body)
        header.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        session.dataTask(with: urlRequest) { [decoder] data, response, error in
            do {
                let result: T.Response = try decoder.decode(T.Response.self, from: data ?? .init())
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

