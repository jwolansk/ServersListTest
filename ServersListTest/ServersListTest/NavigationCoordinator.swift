//
//  NavigationCoordinator.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Common
import Foundation
import Servers
import SwiftUI

class NavigationCoordinator {
    @Published var isReadyForHome: Bool = false

    private var sessionManager: SessionManager

    init() {
        self.sessionManager = SLApplication.sessionManager
        sessionManager.isLoggedIn
            .combineLatest(SLApplication.serversDataManager.isDataReady)
            .map { $0 && $1 }
            .assign(to: &$isReadyForHome)
    }

    @ViewBuilder
    static var rootNavigationView: some View {
        AppNavigationView()
    }

    @ViewBuilder
    static var rootView: some View {
        if let viewModel: MainViewViewModel = SLApplication.viewModelFactory.create() {
            MainView(viewModel: viewModel)
        }
        EmptyView()
    }
}

struct AppNavigationView: View {
    @State private var isShowingDetailView = false

    private let navigationCoordinator = NavigationCoordinator()

    var body: some View {
        NavigationView {
            VStack {
                NavigationCoordinator.rootView
                NavigationLink(destination: Group {
                    // TODO: normally with full app this conditional view creation should be a part of dedicated view provider object
                    if let viewModel: ServersListViewModel = SLApplication.viewModelFactory.create() {
                        ServersList(viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                    }
                }, isActive: $isShowingDetailView) { EmptyView() }
            }
        }
        .navigationBarHidden(true)
        .onReceive(navigationCoordinator.$isReadyForHome) { isReadyForHome in
            isShowingDetailView = isReadyForHome
        }
    }
}
