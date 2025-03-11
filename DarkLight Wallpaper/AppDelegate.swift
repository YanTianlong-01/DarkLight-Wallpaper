//
//  AppDelegate.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import SwiftUI
import KeyboardShortcuts

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var preferencesWindow: NSWindow?
    @EnvironmentObject var appState: AppState

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        KeyboardShortcuts.onKeyUp(for: .switchWallpaper) { // 快捷键生效
            AppState.wallpaperManager.setRandomWallpaper(AppState.wallpaperManager.lightFolderPath, AppState.wallpaperManager.darkFolderPath)
        }
        
        if let button = statusItem?.button {
            button.image = NSImage(named: "AppIcon")
            button.image?.size = NSSize(width: 20, height: 20)
//            if let appIcon = NSImage(named: "AppIcon") {
//                // 创建带圆角的图像
//                let roundedImage = appIcon.withRoundedCorners(radius: 20) // 半径根据需要调整
//                button.image = roundedImage
//                button.image?.size = NSSize(width: 20, height: 20) // 设置图标大小
//            }
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: NSLocalizedString("About", comment: "") + " DarkLight Wallpaper (for Mac)", action: #selector(openAppWebsite), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: NSLocalizedString("Preference", comment: ""), action: #selector(openPreferences), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("Quit", comment: ""), action: #selector(quitApp), keyEquivalent: "q"))
        statusItem?.menu = menu
        
        AppState.wallpaperManager.updateTimer(interval: AppState.wallpaperManager.refreshInterval) // 启动计时器
        AppState.wallpaperManager.hideDockBarIcon(hideDockIcon: AppState.wallpaperManager.hideDockIcon)
    }

    @objc func openAppWebsite() {
        if let url = URL(string: "https://github.com/YanTianlong-01/DarkMode-Wallpaper-for-Mac") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func openPreferences() {
        AppState.preferencesWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    @objc func togglePopover(_ sender: Any?) {
        // Optional: 切换popover显示
    }
}
