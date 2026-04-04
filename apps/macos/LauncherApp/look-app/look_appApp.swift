//
//  look_appApp.swift
//  look-app
//
//  Created by kunkka07xx on 2026/04/04.
//

import SwiftUI

@main
struct look_appApp: App {
    @StateObject private var appUIState = AppUIState()
    @StateObject private var themeStore = ThemeStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 620, minHeight: 420)
                .background(WindowConfigurator())
                .environmentObject(appUIState)
                .environmentObject(themeStore)
        }
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Theme Settings") {
                    appUIState.showsThemeSettings.toggle()
                }
                .keyboardShortcut(",", modifiers: [.command, .shift])
            }
        }
    }
}
