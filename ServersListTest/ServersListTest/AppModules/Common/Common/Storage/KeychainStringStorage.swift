//
//  KeychainStringStorage.swift
//  Common
//
//  Created by Jakub Wolański on 26/06/2023.
//

import Foundation

public struct KeychainStringStorage {
    private let service: String
    private let account: String

    public init(service: String, account: String) {
        self.service = service
        self.account = account
    }

    public func clearKeychain() {
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
    }

    public func storeInKeychain(_ string: String) {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: string.data(using: .utf8) as Any
        ] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            print("Keychain storage error")
            return
        }
    }

    public func readStringFromKeychain() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess else { return nil }
        return String(data: (result as? Data) ?? Data(), encoding: .utf8)

    }
}
