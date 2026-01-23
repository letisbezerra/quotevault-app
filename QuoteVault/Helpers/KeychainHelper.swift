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

    // Salva a sessão no Keychain
    func save(session: Session) {
        do {
            let data = try JSONEncoder().encode(session)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: sessionKey,
                kSecValueData as String: data
            ]
            // Remove se já existir
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("Erro ao salvar sessão no Keychain: \(error)")
        }
    }

    // Carrega a sessão do Keychain
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
              let data = dataTypeRef as? Data else {
            return nil
        }

        do {
            let session = try JSONDecoder().decode(Session.self, from: data)
            return session
        } catch {
            print("Erro ao decodificar sessão do Keychain: \(error)")
            return nil
        }
    }

    // Limpa a sessão do Keychain
    func clearSession() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: sessionKey
        ]
        SecItemDelete(query as CFDictionary)
    }
}
