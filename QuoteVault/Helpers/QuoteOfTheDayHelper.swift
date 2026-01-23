//
//  QuoteOfTheDayHelper.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation

extension Array where Element == QuoteModel {
    func randomQuoteOfTheDay() -> Element? {
        guard !self.isEmpty else { return nil }
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        let index = day % count
        return self[index]
    }
}
