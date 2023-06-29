//
//  MainView.swift
//  ServersListTest
//
//  Created by Jakub Wolański on 27/06/2023.
//

import Common
import ComposableArchitecture
import Foundation
import Servers
import SwiftUI
import User
import UICommon

struct MainFeature: ReducerProtocol {
    struct State: Equatable {
        var dataLoaded: Bool = false
        var isLoggedInOnStart: Bool = false
        var isLoggedInByUser: Bool = false

        var loginFormState = LoginFormFeature.State()
    }

    enum Action: Equatable {
        case dataLoaded, loggedInOnStart, isLoggedInByUser, loggedOut, loginForm(LoginFormFeature.Action)
    }

    var body: some ReducerProtocolOf<Self> {
        Scope(state: \.loginFormState, action: /Action.loginForm) {
            LoginFormFeature()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case .dataLoaded:
                state.dataLoaded = true
                return .none
            case .loggedInOnStart:
                state.isLoggedInOnStart = true
                return .none
            case .isLoggedInByUser:
                state.isLoggedInByUser = true
                return .none
            case .loggedOut:
                state.isLoggedInOnStart = false
                state.isLoggedInByUser = false
                return .none
            case .loginForm:
                return .none
            }
        }
    }
}

struct MainFeatureView: View {
    let store: StoreOf<MainFeature>

    @State var showLoginForm = false

    var body: some View {
        WithViewStore(store, observe: { $0 }, content: { viewStore in
            VStack {
                Spacer()
                Image("splash")
                    .resizable()
                    .frame(width: 430, height: 378)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea()
            .onAppear() {
                // check login form needed
                withAnimation {
                    showLoginForm = viewStore.isLoggedInOnStart == false
                }
            }
            .overlay() {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 40) {
                            Spacer()
                            if viewStore.isLoggedInByUser == false {
                                Image("logo")
                            }
                            if showLoginForm {
                                LoginFormView(
                                    store: self.store.scope(state: \.loginFormState, action: { action in
                                        switch action {
                                        case .loggedIn:
                                            return .isLoggedInByUser
                                        default:
                                            return .loginForm(action)
                                        }
                                    })
                                )
                            }
                            if viewStore.isLoggedInByUser {
                                VStack(spacing: 6) {
                                    LoadingSpinner()
                                    Text("Loading list")
                                        .font(SLFont.caption.font)
                                        .foregroundColor(SLColor.grayForeground.color)
                                }
                            }
                            Spacer()
                        }
                        .padding(32)
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                    }
                }
                .ignoresSafeArea(.container)
            }
        })
    }
}
