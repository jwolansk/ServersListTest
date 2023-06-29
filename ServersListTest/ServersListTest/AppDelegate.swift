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
        let serversDataManager = ServersDataManager(sessionManager: sessionManager)
        let serversCoordinator = ServersCoordinator(sessionManager: sessionManager, dataManager: serversDataManager)
        SLApplication.initialize(with: Config(),
                                 sessionManager: sessionManager,
                                 serversDataManager: serversDataManager,
                                 viewModelFactory: CompositeViewModelFactory(with: serversCoordinator.viewModelFactory))
    }
}
