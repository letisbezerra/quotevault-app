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
    
    enum CodingKeys: String, CodingKey {
        case id, text, author, category
        case createdAt = "created_at"
    }
}
