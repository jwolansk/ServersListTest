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

    public init(sessionManager: SessionManager) {
        viewModelFactory = [
            SingleViewModelFactory {
                ServersListViewModel(sessionManager: sessionManager)
            }
        ]
    }
}
