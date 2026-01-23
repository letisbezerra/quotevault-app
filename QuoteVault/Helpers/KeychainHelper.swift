//
//  KeychainHelper.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation
import Supabase

final class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    private let sessionKey = "supabase_session"

    /// Saves the session to Keychain
    func save(session: Session) {
        do {
            let data = try JSONEncoder().encode(session)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: sessionKey,
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("Error saving session to Keychain: \(error)")
        }
    }

    /// Loads the session from Keychain
    func loadSession() -> Session? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: sessionKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess,
              let data = dataTypeRef as? Data else { return nil }

        do {
            return try JSONDecoder().decode(Session.self, from: data)
        } catch {
            print("Error decoding session from Keychain: \(error)")
            return nil
        }
    }

    /// Clears the session from Keychain
    func clearSession() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: sessionKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}

