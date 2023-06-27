//
//  ServersListTestApp.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import SwiftUI

@main
struct ServersListTestApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            NavigationCoordinator.rootNavigationView
        }
    }
}
