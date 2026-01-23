//
//  QuoteViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Supabase
import Combine

@MainActor
class QuoteViewModel: ObservableObject {
    @Published var quotes: [QuoteModel] = []
    @Published var filteredQuotes: [QuoteModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedCategory: String? = nil {
        didSet { applyFilters() }
    }
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    
    let categories = ["Motivation", "Love", "Success", "Wisdom", "Humor"]
    
    // Fetch Quotes
    func fetchQuotes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await SupabaseService.client
                .from("quotes")
                .select()
                .order("created_at", ascending: false)
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            quotes = try decoder.decode([QuoteModel].self, from: response.data)
            
            applyFilters()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Filters
    private func applyFilters() {
        filteredQuotes = quotes.filter { quote in
            let matchesCategory = selectedCategory == nil || quote.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                quote.text.localizedCaseInsensitiveContains(searchText) ||
                (quote.author?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesCategory && matchesSearch
        }
    }
    
    // Favorites
    func toggleFavorite(quote: QuoteModel, userId: UUID) {
        guard let index = quotes.firstIndex(where: { $0.id == quote.id }) else { return }
        
        quotes[index].isFavorite.toggle()
        applyFilters()
        
        Task {
            await saveFavoriteToSupabase(quote: quotes[index], userId: userId)
        }
    }
    
    func isFavorite(quote: QuoteModel) -> Bool {
        return quotes.first(where: { $0.id == quote.id })?.isFavorite ?? false
    }
    
    func saveFavoriteToSupabase(quote: QuoteModel, userId: UUID) async {
        do {
            // Verifica se já existe no Supabase
            let response = try await SupabaseService.client
                .from("favorites")
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("quote_id", value: quote.id.uuidString)
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let existingFavs = try decoder.decode([FavoriteModel].self, from: response.data)
            
            if existingFavs.isEmpty {
                // Adiciona favorito
                try await SupabaseService.client
                    .from("favorites")
                    .insert([
                        "user_id": userId.uuidString,
                        "quote_id": quote.id.uuidString
                    ])
                    .execute()
            } else {
                // Remove favorito
                try await SupabaseService.client
                    .from("favorites")
                    .delete()
                    .eq("user_id", value: userId.uuidString)
                    .eq("quote_id", value: quote.id.uuidString)
                    .execute()
            }
            
        } catch {
            print("Erro ao alternar favorito: \(error.localizedDescription)")
        }
    }
}
