////
////  LoginFormFeature.swift
////  User
////
////  Created by Jakub Wolański on 28/06/2023.
////
//
//import Common
//import ComposableArchitecture
//import Foundation
//import SwiftUI
//import UICommon
//
//public struct LoginFormFeature: ReducerProtocol {
//    public struct State: Equatable {
//        var username: String = ""
//        var password: String = ""
//        var error: Bool = false
//        var isLoggedIn: Bool = false
//    }
//
//    public enum Action: Equatable {
//        case passwordChanged(String), usernameChanged(String), error(Bool), loggedIn, validate
//    }
//
//    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
//        switch action {
//        case .passwordChanged(let password):
//            state.password = password
//            return .none
//        case .usernameChanged(let username):
//            state.username = username
//            return .none
//        case .error(let error):
//            state.error = error
//            return .none
//        case .loggedIn:
//            state.isLoggedIn = true
//            return .none
//        case .validate:
//            // TODO: api call
//            return .none
//        }
//    }
//}
//
//public struct LoginFormView: View {
//    let store: StoreOf<LoginFormFeature>
//
//    public var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            VStack(spacing: 16) { // TODO: move strings to some storage
//                TextInputView(icon: Image("user"), placeholder: "Username", text: viewStore.binding(get: \.username, send: {
//                    LoginFormFeature.Action.usernameChanged($0)
//                }))
//                TextInputView(icon: Image("lock"), placeholder: "Password", text: viewStore.binding(get: \.password, send: {
//                    LoginFormFeature.Action.passwordChanged($0)
//                }), isSecure: true)
//                SLButton.Primary(title: "Log in") {
//                    viewStore.send(.validate)
//                }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
//            }
//            .alert("Verification failed", isPresented: viewStore.binding(get: \.error, send: LoginFormFeature.Action.error), actions: {
//
//            }, message: {
//                Text("Your username or password is incorrect.")
//            })
//        }
//    }
//}
//
