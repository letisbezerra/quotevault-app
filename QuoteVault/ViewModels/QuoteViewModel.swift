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
    
    private func applyFilters() {
        filteredQuotes = quotes.filter { quote in
            let matchesCategory = selectedCategory == nil || quote.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                quote.text.localizedCaseInsensitiveContains(searchText) ||
                (quote.author?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesCategory && matchesSearch
        }
    }
}
