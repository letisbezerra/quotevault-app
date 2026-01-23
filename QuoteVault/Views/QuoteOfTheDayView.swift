//
//  QuoteOfTheDayView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct QuoteOfTheDayView: View {
    let quote: QuoteModel

    var body: some View {
        VStack(spacing: 16) {
            // Data de hoje
            Text(todayString())
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Título
            Text("Quote of the Day")
                .font(.title2)
                .bold()

            // Card da quote
            QuoteCardView(quote: quote, style: .colorful)
                .shadow(radius: 5)
                .padding()
        }
        .padding()
    }

    func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // ex: January 22, 2026
        return formatter.string(from: Date())
    }
}
