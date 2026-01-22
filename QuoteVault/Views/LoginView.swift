//
//  LoginView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Text("QuoteVault")
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
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task {
                        await viewModel.signIn()
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
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(viewModel.isLoading)
            }

            Spacer()

            Button("Don't have an account? Sign up") {
                // navegação depois
            }
            .font(.footnote)

        }
        .padding()
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
