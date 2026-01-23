//
//  MainTableView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var settingsVM: SettingsViewModel
    @StateObject private var quoteVM = QuoteViewModel()
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "quote.bubble")
                        Text("Quotes")
                    }

                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }

                QuoteOfTheDayTab(quoteVM: quoteVM)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
//            .sheet(isPresented: $showSettings) {
//                SettingsView()
//                    .environmentObject(settingsVM)
//            }
            .task {
                await quoteVM.fetchQuotes()
            }
        }
    }
}

// Extra Tab simplificado
struct QuoteOfTheDayTab: View {
    @ObservedObject var quoteVM: QuoteViewModel
    
    var body: some View {
        Group {
            if quoteVM.isLoading {
                ProgressView("Loading Quote of the Day...")
            } else if let dailyQuote = quoteVM.quotes.randomQuoteOfTheDay() {
                QuoteOfTheDayView(quote: dailyQuote)
            } else {
                Text("No quotes available for today.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .tabItem {
            Image(systemName: "star.fill")
            Text("Quote of the Day")
        }
    }
}
