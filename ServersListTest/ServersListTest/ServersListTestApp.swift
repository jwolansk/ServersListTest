//
//  ServersListTestApp.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import Servers
import SwiftUI

@main
struct ServersListTestApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @StateObject private var viewModel = AppNavigationViewModel()

    @State private var isShowingDetailView = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    // TODO: normally with full app this conditional view creation should be a part of dedicated view provider object
                    if let viewModel: MainViewViewModel = SLApplication.viewModelFactory.create() {
                        MainView(viewModel: viewModel)
                    }
                    NavigationLink(destination: Group {
                        // TODO: normally with full app this conditional view creation should be a part of dedicated view provider object
                        if let viewModel: ServersListViewModel = SLApplication.viewModelFactory.create() {
                            ServersList(viewModel: viewModel)
                                .navigationBarHidden(true)
                        }
                    }, isActive: $isShowingDetailView) { EmptyView() }
                }
            }
            .navigationBarHidden(true)
            .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
                isShowingDetailView = isLoggedIn
            }
        }
    }
}

class AppNavigationViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    private var sessionManager: SessionManager

    init() {
        self.sessionManager = SLApplication.sessionManager
        sessionManager.isLoggedIn.print("isloggedin").assign(to: &$isLoggedIn)
    }
}
