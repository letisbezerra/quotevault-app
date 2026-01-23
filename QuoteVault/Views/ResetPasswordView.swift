//
//  ResetPasswordView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingSuccessAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Reset Password").font(.largeTitle.bold())

            VStack(spacing: 16) {
                TextField("Enter your email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if let error = viewModel.errorMessage {
                    Text(error).font(.footnote).foregroundColor(.red).multilineTextAlignment(.center)
                }

                Button {
                    Task {
                        await viewModel.resetPassword()
                        if viewModel.errorMessage == nil { showingSuccessAlert = true }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().frame(maxWidth: .infinity).padding()
                    } else {
                        Text("Send Reset Link").fontWeight(.semibold).frame(maxWidth: .infinity).padding()
                    }
                }
                .background(.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(viewModel.isLoading)
            }

            Spacer()
            Button("Back to Login") { dismiss() }.font(.footnote)
        }
        .padding()
        .alert("Check your email for reset instructions!", isPresented: $showingSuccessAlert) {
            Button("OK") { dismiss() }
        }
    }
}

#Preview {
    ResetPasswordView(
        viewModel: AuthViewModel()
    )
}
