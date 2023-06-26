//
//  MainCoordinator.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation

public class MainCoordinator: Coordinator {
    public let viewModelFactory: [any ViewModelFactory]

    public init(sessionManager: SessionManager) {
        viewModelFactory = [
            SingleViewModelFactory {
                MainViewViewModel(sessionManager: sessionManager)
            }
        ]
    }
}
