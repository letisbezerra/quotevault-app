//
//  AuthViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 21/01/26.
//

import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func signUp(email: String, password: String) async {
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password
            )

            self.session = response.session
            self.isAuthenticated = response.session != nil

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )

            self.session = session
            self.isAuthenticated = true

        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func resetPassword(email: String) async {
        do {
            try await supabase.auth.resetPasswordForEmail(email)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
