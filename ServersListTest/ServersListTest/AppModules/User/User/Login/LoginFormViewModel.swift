//
//  LoginFormViewModel.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Combine
import Common
import Foundation

public class LoginFormViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published private(set) var error: String?
    @Published private(set) var isLoggedIn: Bool = false

    private var sessionManager: SessionManager
    private var subscriptions = Set<AnyCancellable>()

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager

        sessionManager.isLoggedIn.assign(to: &$isLoggedIn)
    }

    func send() {
        LoginQuery(username: username, password: password)
            .publisher()
            .sink(receiveCompletion: { [weak self] error in
                self?.error = "Your username or password is incorrect"
            }, receiveValue: { [weak self] result in
                self?.sessionManager.store(token: result.token)
            })
            .store(in: &subscriptions)
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
    let token: String
}
