//
//  AppState.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import SwiftUI

class AppState: ObservableObject {
    static let wallpaperManager = WallpaperManager() // Manager
        
    static private let preferencesView = PreferecneView()
    
    static let preferencesWindow: NSWindow = {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 500),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.contentView = NSHostingView(rootView: preferencesView)
        window.title = "Preferences"
        window.isReleasedWhenClosed = false
        return window
    }()


}
