//
//  MainTableView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//
import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quotes")
                }
                .environmentObject(authVM)

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .environmentObject(authVM)
        }
    }
}
