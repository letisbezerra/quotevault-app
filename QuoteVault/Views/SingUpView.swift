//
//  SingUpView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingSuccessAlert = false
    
    // Closure para passar o email de volta
    var onSignUpSuccess: ((String) -> Void)? = nil

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Create Account")
                .font(.largeTitle.bold())
            
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button("Sign Up") {
                    Task {
                        await viewModel.signUp(email: viewModel.email, password: viewModel.password)
                        
                        if viewModel.isAuthenticated {
                            showingSuccessAlert = true
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(viewModel.isLoading)
            }
            
            Spacer()
            
            Button("Already have an account? Log in") {
                dismiss()
            }
            .font(.footnote)
        }
        .padding()
        .alert("Account created successfully!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                // Passa o email de volta pro LoginView e limpa a senha
                onSignUpSuccess?(viewModel.email)
                dismiss()
            }
        }
    }
}
