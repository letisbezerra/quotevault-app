//
//  LoginView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var activeSheet: ActiveSheet? = nil
    @State private var navigateToHome = false
    @State private var hasCheckedSession = false

    enum ActiveSheet: Identifiable {
        case signUp, resetPassword
        var id: Int { hashValue }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Text("Quote Vault")
                    .font(.largeTitle.bold())
                
                Text("Welcome back")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
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
                    
                    Button {
                        Task {
                            await viewModel.signIn()
                            if viewModel.isAuthenticated {
                                navigateToHome = true
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(viewModel.isLoading)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button("Don't have an account? Sign up") {
                        activeSheet = .signUp
                    }
                    .font(.footnote)
                    
                    Button("Forgot password?") {
                        activeSheet = .resetPassword
                    }
                    .font(.footnote)
                }
            }
            .padding()
            .sheet(item: $activeSheet) { item in
                switch item {
                case .signUp:
                    SignUpView(viewModel: viewModel) { newEmail in
                        viewModel.email = newEmail
                        viewModel.password = ""
                    }
                case .resetPassword:
                    ResetPasswordView(viewModel: viewModel)
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                MainTabView()
                    .environmentObject(viewModel)
            }
            // CHECK LOGIN AUTOMATICO
            .task {
                guard !hasCheckedSession else { return }
                hasCheckedSession = true
                if viewModel.isAuthenticated {
                    navigateToHome = true
                }
            }
        }
    }
}



#Preview {
    LoginView()
}

#Preview("Loading") {
    let vm = AuthViewModel()
    vm.isLoading = true
    return LoginView()
        .environmentObject(vm)
}
