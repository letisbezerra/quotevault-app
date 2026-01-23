//
//  SettingsViewModel.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    @Published var fontSize: Double = 16 {
        didSet {
            // ✅ FIX: Use local variable to avoid recursion
            let newSize = max(12, min(fontSize, 30))
            if newSize != fontSize {
                self.fontSize = newSize  // This will trigger didSet again but with correct value
            }
            UserDefaults.standard.set(newSize, forKey: "fontSize")
        }
    }

    init() {
        // Load saved values
        let savedDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let savedFontSize = UserDefaults.standard.double(forKey: "fontSize")
        
        self.isDarkMode = savedDarkMode
        self.fontSize = savedFontSize
        
        // Fix invalid font size
        if self.fontSize < 12 || self.fontSize > 30 {
            self.fontSize = 16
        }
    }

    func toggleDarkMode() {
        isDarkMode.toggle()
    }

    func increaseFontSize() {
        fontSize += 2
    }

    func decreaseFontSize() {
        fontSize -= 2
    }
    
    func saveSettings() {
        print("Settings saved:")
        print("Dark Mode: \(isDarkMode)")
        print("Font Size: \(fontSize)pt")
    }
}
