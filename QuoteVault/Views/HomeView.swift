//
//  HomeView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Auth
import UIKit

struct HomeView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var settingsVM: SettingsViewModel
    
    private var customBodyFont: Font {
        .system(size: settingsVM.fontSize, design: .default)
    }
    
    private var customCaptionFont: Font {
        .system(size: settingsVM.fontSize * 0.7, design: .default)
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Search bar
                TextField("Search by text or author", text: $viewModel.searchText)
                    .font(customBodyFont)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button("All") {
                            viewModel.selectedCategory = nil
                        }
                        .padding(8)
                        .background(viewModel.selectedCategory == nil ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(viewModel.selectedCategory == nil ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(customCaptionFont)
                        
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(category) {
                                viewModel.selectedCategory = category
                            }
                            .padding(8)
                            .background(viewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .font(customCaptionFont)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Content
                if viewModel.isLoading {
                    ProgressView("Loading Quotes...")
                        .font(customBodyFont)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .font(customBodyFont)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.filteredQuotes.isEmpty {
                    Text("No quotes found.")
                        .font(customBodyFont)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredQuotes, id: \.id) { quote in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\"\(quote.text)\"")
                                        .font(customBodyFont)
                                    
                                    HStack {
                                        Text(quote.author ?? "Unknown")
                                            .font(customCaptionFont)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(quote.category)
                                            .font(customCaptionFont)
                                            .foregroundColor(.blue)
                                            .padding(4)
                                            .background(.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }
                                
                                Spacer()
                                
                                // Favorite button
                                Button {
                                    if let userId = authVM.session?.user.id {
                                        viewModel.toggleFavorite(quote: quote, userId: userId)
                                    }
                                } label: {
                                    Image(systemName: viewModel.isFavorite(quote: quote) ? "heart.fill" : "heart")
                                        .foregroundColor(viewModel.isFavorite(quote: quote) ? .red : .gray)
                                }
                                
                                // Share button
                                Button {
                                    shareQuote(quote)
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.blue)
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
    
    func shareQuote(_ quote: QuoteModel) {
        let lightImage = QuoteCardView(quote: quote, style: .light).snapshot()
        let darkImage = QuoteCardView(quote: quote, style: .dark).snapshot()
        let colorfulImage = QuoteCardView(quote: quote, style: .colorful).snapshot()
        
        let items: [Any] = [lightImage, darkImage, colorfulImage]
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(SettingsViewModel())
}
