//
//  FavoriteViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Supabase
import Combine

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favorites: [FavoriteModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFavorites(for userId: UUID) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await SupabaseService.client
                .from("favorites")
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            favorites = try decoder.decode([FavoriteModel].self, from: response.data)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func toggleFavorite(quote: QuoteModel, userId: UUID) async {
        do {
            if isFavorite(quoteId: quote.id) {
                // Remover favorito
                try await SupabaseService.client
                    .from("favorites")
                    .delete()
                    .eq("quote_id", value: quote.id.uuidString)
                    .eq("user_id", value: userId.uuidString)
                    .execute()
            } else {
                // Adicionar favorito
                try await SupabaseService.client
                    .from("favorites")
                    .insert([
                        "user_id": userId.uuidString,
                        "quote_id": quote.id.uuidString
                    ])
                    .execute()
            }
        } catch {
            print("Erro ao alternar favorito: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(quoteId: UUID) -> Bool {
        favorites.contains { $0.quoteId == quoteId }
    }
}
