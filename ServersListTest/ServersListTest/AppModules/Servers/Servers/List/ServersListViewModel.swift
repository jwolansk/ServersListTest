//
//  ServersListViewModel.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation

public class ServersListViewModel: ObservableObject {
    @Published private(set) var servers = [Server]()

    func onAppear() {
        loadServers()
    }

    private func loadServers() {
        let query = ServersQuery()
        query.publisher()
            .replaceError(with: [Server]())
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
