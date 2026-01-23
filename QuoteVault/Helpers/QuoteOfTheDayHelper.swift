//
//  QuoteOfTheDayHelper.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import Foundation

extension Array where Element == QuoteModel {
    /// Returns a quote of the day based on the current day
    func randomQuoteOfTheDay() -> Element? {
        guard !self.isEmpty else { return nil }
        let day = Calendar.current.component(.day, from: Date())
        return self[day % count]
    }
}

