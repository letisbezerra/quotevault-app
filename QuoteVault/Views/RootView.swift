////
////  RootView.swift
////  QuoteVault
////
////  Created by Leticia Bezerra on 22/01/26.
////
//
//import SwiftUI
//
//struct RootView: View {
//    @EnvironmentObject var authVM: AuthViewModel
//
//    var body: some View {
//        // Usa ZStack pra trocar de tela sem quebrar EnvironmentObject
//        ZStack {
//            if authVM.isLoggedIn {
//                MainTabView()
//            } else {
//                LoginView()
//            }
//        }
//    }
//}
