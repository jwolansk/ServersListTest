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

    public init() {
        viewModelFactory = [
            SingleViewModelFactory {
                ServersListViewModel()
            }
        ]
    }
}
