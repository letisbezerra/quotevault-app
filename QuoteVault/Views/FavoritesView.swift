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
                } else if filteredFavorites.isEmpty {
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
                                    Image(systemName: favoriteVM.isFavorite(quoteId: quote.id) ? "heart.fill" : "heart")
                                        .foregroundColor(favoriteVM.isFavorite(quoteId: quote.id) ? .red : .gray)
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
        // Filtra os quotes que estão na lista de favoritos
        quoteVM.quotes.filter { quote in
            favoriteVM.isFavorite(quoteId: quote.id)
        }
    }
    
    // MARK: - Helpers
    private func loadData() async {
        guard let userId = authVM.session?.user.id else { return }
        await quoteVM.fetchQuotes()                // Carrega todos os quotes primeiro
        await favoriteVM.fetchFavorites(for: userId) // Depois carrega os favoritos do usuário
    }
    
    private func toggleFavorite(quote: QuoteModel) {
        guard let userId = authVM.session?.user.id else { return }
        Task {
            await favoriteVM.toggleFavorite(quote: quote, userId: userId)
            await favoriteVM.fetchFavorites(for: userId) // Atualiza só a lista de favoritos
        }
    }
}
