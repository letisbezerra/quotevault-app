//
//  MainTabView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var settingsVM = SettingsViewModel()
    @StateObject private var quoteVM = QuoteViewModel()
    @State private var showSettings = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Image(systemName: "quote.bubble"); Text("Quotes") }
                .environmentObject(settingsVM)

            FavoritesView()
                .tabItem { Image(systemName: "heart.fill"); Text("Favorites") }
                .environmentObject(settingsVM)

            Group {
                if quoteVM.isLoading {
                    ProgressView("Loading...")
                } else if let dailyQuote = quoteVM.quotes.randomQuoteOfTheDay() {
                    QuoteOfTheDayView(quote: dailyQuote)
                        .environmentObject(settingsVM)
                } else {
                    Text("No quotes available.").foregroundColor(.secondary)
                }
            }
            .tabItem { Image(systemName: "star.fill"); Text("Quote of the Day") }
        }
        .sheet(isPresented: $showSettings) { SettingsView().environmentObject(settingsVM) }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showSettings.toggle() } label: { Image(systemName: "gearshape") }
            }
        }
        .preferredColorScheme(settingsVM.isDarkMode ? .dark : .light)
        .task { await quoteVM.fetchQuotes() }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(SettingsViewModel())
}

