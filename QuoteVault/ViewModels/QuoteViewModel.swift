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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
