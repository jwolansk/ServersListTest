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

    private let service = "servers.list.test"
    private let account = "token"

    public init() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess else { return }
        guard let token = String(data: (result as? Data) ?? Data(), encoding: .utf8) else { return }
        tokenStorage = token
        isLoggedInSubject.send(true)
    }

    public func store(token: String) {
        tokenStorage = token
        isLoggedInSubject.send(true)

        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: token.data(using: .utf8) as Any
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            print("Keychain storage error")
            return
        }
    }
    public func logout() {

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Keychain storage error")
            return
        }

        tokenStorage = nil
        isLoggedInSubject.send(false)
    }
    public var token: String? { tokenStorage }

    private var tokenStorage: String?
}
