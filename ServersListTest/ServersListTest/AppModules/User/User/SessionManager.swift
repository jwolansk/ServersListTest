//
//  SessionManager.swift
//  User
//
//  Created by Jakub Wolański on 23/06/2023.
//

import Common
import Foundation

public class SLSessionManager: SessionManager {
    public init() {}

    public func store(token: String) {
        tokenStorage = token
    }
    public func logout() {
        tokenStorage = nil
    }
    public var token: String? { tokenStorage }

    private var tokenStorage: String?
}
