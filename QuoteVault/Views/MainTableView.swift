//
//  MainTableView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var quoteVM = QuoteViewModel() // pega as quotes

    var body: some View {
        TabView {
            // Aba Quotes
            HomeView()
                .tabItem {
                    Image(systemName: "quote.bubble")
                    Text("Quotes")
                }

            // Aba Favorites
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }

            // Aba Quote of the Day
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
        .task {
            await quoteVM.fetchQuotes() // carrega as quotes ao iniciar
        }
    }
}
