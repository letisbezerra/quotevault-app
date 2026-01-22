//
//  FavoriteModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation

struct FavoriteModel: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let quoteId: UUID
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case quoteId = "quote_id"
        case createdAt = "created_at"
    }
}
