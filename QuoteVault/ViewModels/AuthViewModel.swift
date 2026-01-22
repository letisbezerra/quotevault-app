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
            errorMessage = "Please enter email and password"
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
    
    func signUp(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await SupabaseService.client.auth.signUp(
                email: email,
                password: password
            )

            // Se a sessão existir, autentica
            if let session = response.session {
                self.session = session
                self.isAuthenticated = true
            } else if response.user != nil {
                // Usuário criado, mas sem sessão
                self.isAuthenticated = true
            }

        } catch {
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }

        isLoading = false
    }
    
//    func signUp(email: String, password: String) async {
//        guard !email.isEmpty, !password.isEmpty else {
//            errorMessage = "Please enter email and password"
//            return
//        }
//
//        isLoading = true
//        errorMessage = nil
//
//        do {
//            let response = try await SupabaseService.client.auth.signUp(
//                email: email,
//                password: password
//            )
//
//            self.session = response.session
//            self.isAuthenticated = response.session != nil
//
//        } catch {
//            self.errorMessage = error.localizedDescription
//            self.isAuthenticated = false
//        }
//
//        isLoading = false
//    }

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
            errorMessage = "Please enter your email"
            return
        }

        do {
            try await SupabaseService.client.auth.resetPasswordForEmail(email)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
