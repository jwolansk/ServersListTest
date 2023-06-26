//
//  ServersListViewModel.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation

public class ServersListViewModel: ObservableObject {
    enum SortMethod { case alphabetical, distance }

    @Published private(set) var servers = [Server]()
    @Published var sortMethod = SortMethod.distance

    private let sessionManager: SessionManager?

    init(sessionManager: SessionManager? = nil) {
        self.sessionManager = sessionManager
    }

    func onAppear() {
        loadServers()
    }

    func logout() {
        sessionManager?.logout()
    }

    private func loadServers() {
        let query = ServersQuery()
        query.publisher()
            .replaceError(with: [Server]())
            .combineLatest($sortMethod)
            .map { servers, sort in
                return servers.sorted(by: { lhs, rhs in
                    switch sort {
                    case .distance: return lhs.distance < rhs.distance
                    case .alphabetical: return lhs.name < rhs.name
                    }
                })
            }
            .assign(to: &$servers)
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
