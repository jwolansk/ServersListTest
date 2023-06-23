//
//  Network.swift
//  Common
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Combine
import Foundation

public protocol SessionManager {
    func store(token: String)
    func logout()
    var token: String? { get }
}

public protocol NetworkQuery {
    var requestPath: String { get }
    var headers: [String: String] { get }
    associatedtype Result: Decodable
}

struct NetworkConfiguration {
    static var apiBaseUrl = ""
    static func configure(apiBaseUrl: String) {
        NetworkConfiguration.apiBaseUrl = apiBaseUrl
    }
}

// TODO: refactor URLSession storage
public class Network<Query: NetworkQuery> {

    public static func send(with query: Query, completion: @escaping (Query.Result) -> Void) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: NetworkConfiguration.apiBaseUrl + query.requestPath) else {
            let msg = "Network, invalid base URL!!! Please set Network.apiBaseUrl first"
            fatalError(msg)
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = query.headers

        let task = session.dataTask(with: request) { data, response, error in
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
