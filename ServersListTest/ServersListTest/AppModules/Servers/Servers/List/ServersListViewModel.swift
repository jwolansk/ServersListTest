//
//  ServersListViewModel.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Combine
import Common
import Foundation

public class ServersListViewModel: ObservableObject {
    enum SortMethod { case alphabetical, distance }

    @Published private(set) var servers = [Server]()
    @Published var sortMethod = SortMethod.distance

    private let sessionManager: SessionManager?
    private let dataManager: ServersDataManager
    private let serversStorageName = "servers.data"
    private var subscriptions = Set<AnyCancellable>()

    init(sessionManager: SessionManager? = nil, dataManager: ServersDataManager) {
        self.sessionManager = sessionManager
        self.dataManager = dataManager

        dataManager.$servers
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

    func logout() {
        sessionManager?.logout()
    }
}
