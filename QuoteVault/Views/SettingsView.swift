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
                    Toggle(isOn: $settingsVM.isDarkMode) { Text("Dark Mode") }
                }

                Section(header: Text("Font")) {
                    HStack(spacing: 12) {
                        Text("Font Size").frame(width: 80, alignment: .leading)

                        Button { settingsVM.decreaseFontSize() } label: {
                            Image(systemName: "minus.circle.fill").font(.title2).foregroundColor(.red).frame(width: 44, height: 44)
                        }.buttonStyle(PlainButtonStyle())

                        Text("\(Int(settingsVM.fontSize)) pt")
                            .frame(width: 60)
                            .monospaced()
                            .font(.title3)
                            .fontWeight(.medium)

                        Button { settingsVM.increaseFontSize() } label: {
                            Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.blue).frame(width: 44, height: 44)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .contentShape(Rectangle())
                }

                Section {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { isPressed = true }
                        dismiss()
                    } label: {
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
            .toolbar {
                ToolbarItem(placement: .principal) { Text("Settings").font(.largeTitle).bold() }
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(SettingsViewModel())
}
