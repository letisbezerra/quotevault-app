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
            Text(todayString())
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Quote of the Day")
                .font(.title2)
                .bold()

            QuoteCardView(quote: quote, style: .colorful)
                .shadow(radius: 5)
                .padding()
        }
        .padding()
    }

    private func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

#Preview {
    QuoteOfTheDayView(quote: .sampleQuote())
}
