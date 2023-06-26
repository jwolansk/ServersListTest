//
//  UserCoordinator.swift
//  User
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation

public class UserCoordinator: Coordinator {
    public let viewModelFactory: [any ViewModelFactory]

    public init(sessionManager: SessionManager) {
        viewModelFactory = [
            SingleViewModelFactory {
                LoginFormViewModel(sessionManager: sessionManager)
            }
        ]
    }
}
