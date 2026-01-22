//
//  HomeView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = QuoteViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Busca
                TextField("Search by text or author", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Filtros por categoria
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button("All") { viewModel.selectedCategory = nil }
                            .padding(8)
                            .background(viewModel.selectedCategory == nil ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.selectedCategory == nil ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(category) { viewModel.selectedCategory = category }
                                .padding(8)
                                .background(viewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Conteúdo
                if viewModel.isLoading {
                    ProgressView("Loading Quotes...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.filteredQuotes.isEmpty {
                    Text("No quotes found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(viewModel.filteredQuotes) { quote in
                        VStack(alignment: .leading, spacing: 8) {
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
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.fetchQuotes()
                    }
                }
            }
            .navigationTitle("Quotes")
            .task {
                await viewModel.fetchQuotes()
            }
        }
    }
}

#Preview {
    HomeView()
}

