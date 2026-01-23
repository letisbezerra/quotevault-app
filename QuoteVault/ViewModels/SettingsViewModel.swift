//
//  SettingsViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode = false
    @Published var fontSize = 16.0
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        fontSize = UserDefaults.standard.double(forKey: "fontSize")
        if fontSize < 12 { fontSize = 12 }
        if fontSize > 30 { fontSize = 30 }
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
    
    func increaseFontSize() {
        if fontSize < 30 {
            fontSize += 2
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
    }
    
    func decreaseFontSize() {
        if fontSize > 12 {
            fontSize -= 2
            UserDefaults.standard.set(fontSize, forKey: "fontSize")
        }
    }
}
