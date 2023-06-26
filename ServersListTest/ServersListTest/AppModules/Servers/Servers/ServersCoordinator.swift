//
//  ServersCoordinator.swift
//  Servers
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation

public class ServersCoordinator: Coordinator {
    public let viewModelFactory: [any ViewModelFactory]
    public let dataManager: ServersDataManager

    public init(sessionManager: SessionManager, dataManager: ServersDataManager) {
        let dataManager = ServersDataManager(sessionManager: sessionManager)
        self.dataManager = dataManager

        viewModelFactory = [
            SingleViewModelFactory {
                ServersListViewModel(sessionManager: sessionManager, dataManager: dataManager)
            }
        ]
    }
}
