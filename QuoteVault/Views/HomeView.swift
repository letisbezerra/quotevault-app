//
//  HomeView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Auth

struct HomeView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                // Barra de busca
                TextField("Search by text or author", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Filtros por categoria
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
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
                    List {
                        ForEach(viewModel.filteredQuotes, id: \.id) { quote in
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
                                    if let userId = authVM.session?.user.id {
                                        viewModel.toggleFavorite(quote: quote, userId: userId)
                                    } else {
                                        print("Usuário não logado!")
                                    }
                                } label: {
                                    Image(systemName: viewModel.isFavorite(quote: quote) ? "heart.fill" : "heart")
                                        .foregroundColor(viewModel.isFavorite(quote: quote) ? .red : .gray)
                                }
                            }
                            .padding(.vertical, 8)
                        }
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
        .environmentObject(AuthViewModel()) // Certifica que AuthVM está disponível
}
