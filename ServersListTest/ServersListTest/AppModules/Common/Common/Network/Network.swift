//
//  Network.swift
//  Common
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Combine
import Foundation

public protocol SessionManager {
    var isLoggedIn: AnyPublisher<Bool, Never> { get }
    func store(token: String)
    func logout()
    var token: String? { get }
}

public enum HTTPMethod: String { case get = "GET", post = "POST" }

public protocol NetworkQuery {
    var method: HTTPMethod { get }
    var requestPath: String { get }
    var requiresAuthorization: Bool { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
    associatedtype Result: Decodable
}

struct NetworkConfiguration {
    static var apiBaseUrl = ""
    static func configure(apiBaseUrl: String) {
        NetworkConfiguration.apiBaseUrl = apiBaseUrl
    }

    static let session = URLSession(configuration: .default)
}

public class Network<Query: NetworkQuery> {

    public static func send(with query: Query) async throws -> Query.Result {
        guard NetworkConfiguration.apiBaseUrl.isEmpty == false else { throw URLError(.badURL) }

        guard var components = URLComponents(string: NetworkConfiguration.apiBaseUrl + query.requestPath) else {
            let msg = "Network, invalid base URL!!! Please set Network.apiBaseUrl first"
            throw URLError(.badURL)
        }
        components.queryItems = query.parameters.map { key, value in
                URLQueryItem(name: key, value: value)
        }

        // The server doesn't support parameters in body, requires the components in the url
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else { fatalError("invalid url components") }
        var request = URLRequest(url: url)

        request.allHTTPHeaderFields = query.headers
        if let token = SLApplication.sessionManager.token, query.requiresAuthorization {
            request.allHTTPHeaderFields = query.headers.merging(["Authorization": "Bearer \(token)"]) { (_, new) in new }
        }
        request.httpMethod = query.method.rawValue

        print(request.curlString)

        let (data, _) = try await NetworkConfiguration.session.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(Query.Result.self, from: data)
    }

    public static func send(with query: Query, completion: @escaping (Query.Result) -> Void) {

        guard NetworkConfiguration.apiBaseUrl.isEmpty == false else { return }

        guard var components = URLComponents(string: NetworkConfiguration.apiBaseUrl + query.requestPath) else {
            let msg = "Network, invalid base URL!!! Please set Network.apiBaseUrl first"
            fatalError(msg)
        }
        components.queryItems = query.parameters.map { key, value in
                URLQueryItem(name: key, value: value)
        }

        // The server doesn't support parameters in body, requires the components in the url
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else { fatalError("invalid url components") }
        var request = URLRequest(url: url)

        request.allHTTPHeaderFields = query.headers
        if let token = SLApplication.sessionManager.token, query.requiresAuthorization {
            request.allHTTPHeaderFields = query.headers.merging(["Authorization": "Bearer \(token)"]) { (_, new) in new }
        }
        request.httpMethod = query.method.rawValue

        print(request.curlString)

        let task = NetworkConfiguration.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Query.Result.self, from: data)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

public extension NetworkQuery {
    func publisher() -> AnyPublisher<Result, Error> {
        Deferred<PassthroughSubject<Result, Error>> {
            let subject = PassthroughSubject<Result, Error>()
            Network.send(with: self) { result in
                subject.send(result)
            }
            return subject
        }
        .eraseToAnyPublisher()
    }
}

extension URLRequest {

    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }

}
