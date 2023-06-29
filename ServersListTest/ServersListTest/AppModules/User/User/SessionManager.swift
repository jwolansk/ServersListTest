//
//  SessionManager.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Combine
import Common
import Foundation

public class SLSessionManager: SessionManager {
    public var isLoggedIn: AnyPublisher<Bool, Never> { isLoggedInSubject.eraseToAnyPublisher() }
    public var token: String? { tokenStorage.readStringFromKeychain() }

    private var tokenStorage = KeychainStringStorage(service: "servers.list.test", account: "servers.list.test")
    private var isLoggedInSubject = CurrentValueSubject<Bool, Never>(false)

    public init() {
        if token != nil {
            isLoggedInSubject.send(true)
        }
    }

    public func store(token: String) {
        tokenStorage.storeInKeychain(token)
        isLoggedInSubject.send(true)
    }

    public func logout() {
        tokenStorage.clearKeychain()
        isLoggedInSubject.send(false)
    }
}
