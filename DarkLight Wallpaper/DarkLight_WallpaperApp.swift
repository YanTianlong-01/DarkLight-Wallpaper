//
//  DarkLight_WallpaperApp.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let switchWallpaper = Self("switchWallpaper")
}

@main
struct DarkLight_WallpaperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var wallpaperManager = WallpaperManager()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
