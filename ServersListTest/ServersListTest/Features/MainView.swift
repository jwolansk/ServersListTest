//
//  MainView.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 27/06/2023.
//

import Common
import ComposableArchitecture
import Foundation
import SwiftUI
import UICommon
import User

struct MainFeature: ReducerProtocol {
    struct State: Equatable {
        var dataLoaded: Bool
        var isLoggedInOnStart: Bool
        var isLoggedInByUser: Bool
    }

    enum Action: Equatable {
        case dataLoaded, loggedInOnStart, isLoggedInByUser, loggedOut
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .dataLoaded:
            state.dataLoaded = true
            return .none
        case .loggedInOnStart:
            state.isLoggedInOnStart = true
            return .none
        case .isLoggedInByUser:
            state.isLoggedInByUser = true
        case .loggedOut:
            state.isLoggedInOnStart = false
            state.isLoggedInByUser = false
            return .none
        }
    }
}

struct MainFeatureView: View {
    let store: StoreOf<MainFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                Image("splash")
                    .resizable()
                    .frame(width: 430, height: 378)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea()
            .overlay() {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 40) {
                            Spacer()
                            if viewStore.isLoggedInOnStart {
                                Image("logo")
                            }
                            if let viewModel: LoginFormViewModel = SLApplication.viewModelFactory.create() {
                                LoginForm(viewModel: viewModel)
                                    .hidden(viewStore.publisher.map { $0.isLoggedInOnStart })
                            }
                            VStack(spacing: 6) {
                                LoadingSpinner()
                                Text("Loading list")
                                    .font(SLFont.caption.font)
                                    .foregroundColor(SLColor.grayForeground.color)
                            }
                            .hidden(viewStore.publisher.map { $0.isLoggedInByUser })
                            Spacer()
                        }
                        .padding(32)
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                    }
                }
                .ignoresSafeArea(.container)
            }
        }
    }
}
