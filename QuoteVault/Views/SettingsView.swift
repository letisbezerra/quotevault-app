//
//  SettingsView.swift
//  QuoteVault
//
//  Created by Leticia Bezerra on 22/01/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isPressed = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $settingsVM.isDarkMode) {
                        Text("Dark Mode")
                    }
                }

                Section(header: Text("Font")) {
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Button(action: { settingsVM.decreaseFontSize() }) {
                            Image(systemName: "minus.circle")
                        }
                        Text("\(Int(settingsVM.fontSize)) pt")
                            .frame(width: 50)
                        Button(action: { settingsVM.increaseFontSize() }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }

                Section {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressed = true
                        }
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPressed = false
                            }
                        }
                    }) {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isPressed ? Color.blue.opacity(0.7) : Color.blue)
                            .cornerRadius(10)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            // Centraliza título com fonte maior
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
