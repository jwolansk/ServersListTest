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

    private var isLoggedInSubject = CurrentValueSubject<Bool, Never>(false)

    public init() {}

    public func store(token: String) {
        tokenStorage = token
        isLoggedInSubject.send(true)
    }
    public func logout() {
        tokenStorage = nil
        isLoggedInSubject.send(false)
    }
    public var token: String? { tokenStorage }

    private var tokenStorage: String?
}
