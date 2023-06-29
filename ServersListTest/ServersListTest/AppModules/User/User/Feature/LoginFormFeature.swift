//
//  LoginFormFeature.swift
//  User
//
//  Created by Jakub Wolański on 28/06/2023.
//

import Common
import ComposableArchitecture
import Foundation
import SwiftUI
import UICommon

public struct LoginFormFeature: ReducerProtocol {
    public struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var error: Bool = false
        var isLoggedIn: Bool = false

        public init(username: String = "tesonet", password: String = "partyanimal", error: Bool = false, isLoggedIn: Bool = false) {
            self.username = username
            self.password = password
            self.error = error
            self.isLoggedIn = isLoggedIn
        }
    }

    public enum Action: Equatable {
        case passwordChanged(String), usernameChanged(String), error(Bool), loggedIn(String), validate
    }

    public init() {}

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .passwordChanged(let password):
            state.password = password
            return .none
        case .usernameChanged(let username):
            state.username = username
            return .none
        case .error(let error):
            state.error = error
            return .none
        case .loggedIn:
            state.isLoggedIn = true
            return .none
        case .validate:
            return .run { [state] send in
                let query = LoginQuery(username: state.username, password: state.password)
                let data = try await Network.send(with: query)
                guard let token = data.token else { await send(.error(true)); return }
                await send(.loggedIn(token))
            }
        }
    }
}

public struct LoginFormView: View {
    let store: StoreOf<LoginFormFeature>

    public init(store: StoreOf<LoginFormFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) { // TODO: move strings to some storage
                TextInputView(icon: Image("user"), placeholder: "Username", text: viewStore.binding(get: \.username, send: {
                    LoginFormFeature.Action.usernameChanged($0)
                }))
                TextInputView(icon: Image("lock"), placeholder: "Password", text: viewStore.binding(get: \.password, send: {
                    LoginFormFeature.Action.passwordChanged($0)
                }), isSecure: true)
                SLButton.Primary(title: "Log in") {
                    viewStore.send(.validate)
                }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
            .alert("Verification failed", isPresented: viewStore.binding(get: \.error, send: LoginFormFeature.Action.error), actions: {

            }, message: {
                Text("Your username or password is incorrect.")
            })
        }
    }
}

struct LoginQuery: NetworkQuery {
    var requiresAuthorization: Bool { false }

    var method: HTTPMethod { .post }

    typealias Result = Token

    var requestPath: String { "tokens"}

    var headers: [String: String] = [:]
    var parameters: [String: String] = [:]

    init(username: String, password: String) {
        self.parameters = [
            "username": username,
            "password": password
        ]
    }
}

struct Token: Decodable {
    let token: String?
    let message: String?
}
