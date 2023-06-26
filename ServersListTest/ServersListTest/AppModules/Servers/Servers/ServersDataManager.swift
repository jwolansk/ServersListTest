//
//  ServersDataManager.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Combine
import Common
import Foundation

public class ServersDataManager: DataProvider {

    public var isDataReady: AnyPublisher<Bool, Never> { isDataReadySubject.eraseToAnyPublisher() }
    @Published private(set) var servers = [Server]()

    private var isDataReadySubject = CurrentValueSubject<Bool, Never>(false)
    private let sessionManager: SessionManager?
    private let serversStorageName = "servers.data"
    private var subscriptions = Set<AnyCancellable>()

    public init(sessionManager: SessionManager? = nil) {
        self.sessionManager = sessionManager

        bindLoggedInDataLoad()
        readServersCache()
        bindServersCache()
    }

    private func bindLoggedInDataLoad() {
        sessionManager?.isLoggedIn.sink(receiveValue: { [weak self] isLoggedIn in
            guard isLoggedIn else {
                self?.servers = [Server]()
                return
            }
            self?.loadServers()
        }).store(in: &subscriptions)

        $servers.map { $0.isEmpty == false }
            .sink(receiveValue: isDataReadySubject.send)
            .store(in: &subscriptions)
    }

    private func loadServers() {
        // delay to simulate network lag to show spinner state
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let query = ServersQuery()
            query.publisher()
                .replaceError(with: [Server]())
                .assign(to: &self.$servers)
        }
    }

    // MARK: servers persistence
    private func readServersCache() {
        do {
            if let cached: [Server] = try CodableStorage.read(filename: serversStorageName) {
                servers = cached
            }
        } catch {
            print("Error reading servers cache")
        }
    }

    private func bindServersCache() {
        $servers.sink { [serversStorageName] servers in
            do {
                try CodableStorage.store(servers, filename: serversStorageName)
            } catch {
                print("servers persistent storage failed")
            }
        }.store(in: &subscriptions)
    }

}

struct ServersQuery: NetworkQuery {
    var requiresAuthorization: Bool { true }

    var method: HTTPMethod { .get }

    var parameters: [String: String] = [:]

    let requestPath: String = "servers"
    var headers: [String: String] { [:] }
    typealias Result = [Server]
}
