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

    // Inputs da View
    @Published var email: String = ""
    @Published var password: String = ""

    // Estados da tela
    @Published var session: Session?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Preencha email e senha."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let session = try await SupabaseService.client.auth.signIn(
                email: email,
                password: password
            )

            self.session = session
            self.isAuthenticated = true

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signUp() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Preencha email e senha."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await SupabaseService.client.auth.signUp(
                email: email,
                password: password
            )

            self.session = response.session
            self.isAuthenticated = response.session != nil

        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func signOut() async {
        do {
            try await SupabaseService.client.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func resetPassword() async {
        guard !email.isEmpty else {
            errorMessage = "Informe seu email."
            return
        }

        do {
            try await SupabaseService.client.auth.resetPasswordForEmail(email)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
