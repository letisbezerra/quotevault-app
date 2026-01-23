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

    private var customBodyFont: Font { .system(size: settingsVM.fontSize, design: .default) }
    private var customCaptionFont: Font { .system(size: settingsVM.fontSize * 0.7, design: .default) }

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
                        Button("All") { viewModel.selectedCategory = nil }
                            .categoryButton(isSelected: viewModel.selectedCategory == nil, font: customCaptionFont)

                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(category) { viewModel.selectedCategory = category }
                                .categoryButton(isSelected: viewModel.selectedCategory == category, font: customCaptionFont)
                        }
                    }
                    .padding(.horizontal)
                }

                Divider()

                // Quotes list
                if viewModel.isLoading {
                    ProgressView("Loading Quotes...").font(customBodyFont).padding()
                } else if let error = viewModel.errorMessage {
                    Text(error).font(customBodyFont).foregroundColor(.red).padding()
                } else if viewModel.filteredQuotes.isEmpty {
                    Text("No quotes found.").font(customBodyFont).foregroundColor(.secondary).padding()
                } else {
                    List(viewModel.filteredQuotes, id: \.id) { quote in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\"\(quote.text)\"").font(customBodyFont)
                                HStack {
                                    Text(quote.author ?? "Unknown").font(customCaptionFont).foregroundColor(.secondary)
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
                            Button { if let userId = authVM.session?.user.id { viewModel.toggleFavorite(quote: quote, userId: userId) } } label: {
                                Image(systemName: viewModel.isFavorite(quote: quote) ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.isFavorite(quote: quote) ? .red : .gray)
                            }

                            // Share button
                            Button { shareQuote(quote) } label: {
                                Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.fetchQuotes() }
                }
            }
            .navigationTitle("Quotes")
            .task { await viewModel.fetchQuotes() }
        }
    }

    private func shareQuote(_ quote: QuoteModel) {
        let items: [Any] = [
            QuoteCardView(quote: quote, style: .light).snapshot(),
            QuoteCardView(quote: quote, style: .dark).snapshot(),
            QuoteCardView(quote: quote, style: .colorful).snapshot()
        ]

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            rootVC.present(activityVC, animated: true)
        }
    }

}

private extension Button {
    func categoryButton(isSelected: Bool, font: Font) -> some View {
        self.padding(8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .font(font)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(SettingsViewModel())
}
