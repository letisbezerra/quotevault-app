//
//  QuoteModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation

struct QuoteModel: Codable, Identifiable {
    let id: UUID
    let text: String
    let author: String?
    let category: String
    let createdAt: Date?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, text, author, category
        case createdAt = "created_at"
    }
}

extension QuoteModel {
    static func sampleQuote(
        text: String = "Life is what happens when you're busy making other plans.",
        author: String? = "John Lennon",
        category: String = "Motivation",
        createdAt: Date = Date()
    ) -> QuoteModel {
        QuoteModel(id: UUID(), text: text, author: author, category: category, createdAt: createdAt)
    }
}

