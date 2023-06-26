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
            // TODO: normally with full app this conditional view creation should be a part of dedicated view provider object
            if let viewModel: MainViewViewModel = SLApplication.viewModelFactory.create() {
                MainView(viewModel: viewModel)
            }
        }
    }
}
