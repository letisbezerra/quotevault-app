//
//  QuoteCardView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct QuoteCardView: View {
    let quote: QuoteModel
    let style: CardStyle

    enum CardStyle { case light, dark, colorful }

    var body: some View {
        ZStack {
            background
            VStack {
                Text("“\(quote.text)”")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                Text(quote.author ?? "Unknown")
                    .font(.caption)
                    .padding(.bottom, 8)
            }
            .foregroundColor(foreground)
        }
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    private var background: Color {
        switch style {
        case .light: return .white
        case .dark: return .black
        case .colorful: return Color.blue.opacity(0.8)
        }
    }

    private var foreground: Color {
        switch style {
        case .dark, .colorful: return .white
        default: return .black
        }
    }
}

#Preview {
    QuoteCardView(quote: .sampleQuote(), style: .colorful)
}

