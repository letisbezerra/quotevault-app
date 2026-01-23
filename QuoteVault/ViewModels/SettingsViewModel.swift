//
//  SettingsViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: Double = 16

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func increaseFontSize() {
        fontSize = min(fontSize + 2, 30)
    }

    func decreaseFontSize() {
        fontSize = max(fontSize - 2, 12)
    }
}


