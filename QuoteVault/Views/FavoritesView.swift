//
//  FavoritesView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Auth

struct FavoritesView: View {
    @StateObject private var favoriteVM = FavoriteViewModel()
    @StateObject private var quoteVM = QuoteViewModel()
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if favoriteVM.isLoading || quoteVM.isLoading {
                    ProgressView("Loading favorites...")
                        .padding()
                } else if let error = favoriteVM.errorMessage ?? quoteVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if favoriteVM.favorites.isEmpty {
                    Text("You have no favorites yet.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(filteredFavorites) { quote in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("“\(quote.text)”")
                                        .font(.body)
                                    HStack {
                                        Text(quote.author ?? "Unknown")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(quote.category)
                                            .font(.caption2)
                                            .foregroundColor(.blue)
                                            .padding(4)
                                            .background(.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    toggleFavorite(quote: quote)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await loadData()
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                await loadData()
            }
        }
    }
    
    // MARK: - Computed property
    private var filteredFavorites: [QuoteModel] {
        quoteVM.quotes.filter { quote in
            favoriteVM.isFavorite(quoteId: quote.id)
        }
    }
    
    // MARK: - Helpers
    private func loadData() async {
        guard let userId = authVM.session?.user.id else { return }
        await favoriteVM.fetchFavorites(for: userId)
        await quoteVM.fetchQuotes()
    }
    
    private func toggleFavorite(quote: QuoteModel) {
        guard let userId = authVM.session?.user.id else { return }
        Task {
            await favoriteVM.toggleFavorite(quote: quote, userId: userId)
            await loadData() // Atualiza a lista de favoritos após alteração
        }
    }
}
