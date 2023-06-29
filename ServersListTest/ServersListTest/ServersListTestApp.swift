//
//  ServersListTestApp.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import ComposableArchitecture
import SwiftUI

@main
struct ServersListTestApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            MainFeatureView(
                store: Store(initialState: MainFeature.State()) {
                    MainFeature()
                }
            )
        }
    }
}
