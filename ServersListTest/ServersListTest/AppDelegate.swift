//
//  AppDelegate.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import Foundation
import Servers
import UIKit
import User

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupApplication()
        return true
    }

    private func setupApplication() {
        let sessionManager = SLSessionManager()
        let userCoordinator = UserCoordinator(sessionManager: sessionManager)
        let mainCoordinator = MainCoordinator(sessionManager: sessionManager)
        let serversCoordinator = ServersCoordinator(sessionManager: sessionManager)
        SLApplication.initialize(with: Config(),
                                 sessionManager: sessionManager,
                                 viewModelFactory: CompositeViewModelFactory(with: userCoordinator.viewModelFactory +
                                                                             mainCoordinator.viewModelFactory +
                                                                             serversCoordinator.viewModelFactory))
    }
}
