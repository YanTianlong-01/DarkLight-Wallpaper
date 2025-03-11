//
//  WallpaperManager.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import Foundation
import AppKit

class WallpaperManager: ObservableObject {
    @Published var lightFolderPath: String = "" {
        didSet {
            saveBookmark(for: lightFolderPath, key: "LightModeFolderBookmark")
        }
    }
    
    @Published var darkFolderPath: String = "" {
        didSet {
            saveBookmark(for: darkFolderPath, key: "DarkModeFolderBookmark")
        }
    }
    
    @Published var refreshInterval: Int {
        didSet {
            UserDefaults.standard.set(refreshInterval, forKey: "RefreshInterval")
        }
    }
    
    @Published var syncDisplay: Bool {
        didSet {
            UserDefaults.standard.set(syncDisplay, forKey: "SyncDisplay")
        }
    }
    
    @Published var hideDockIcon: Bool {
        didSet {
            UserDefaults.standard.set(hideDockIcon, forKey: "HideDockIcon")
        }
    }

    init() {
        UserDefaults.standard.register(defaults: [
            "RefreshInterval" : 1800,
            "SyncDisplay" : false,
            "HideDockIcon" : false
        ])
        refreshInterval = UserDefaults.standard.integer(forKey: "RefreshInterval")
        syncDisplay = UserDefaults.standard.bool(forKey: "SyncDisplay")
        hideDockIcon = UserDefaults.standard.bool(forKey: "HideDockIcon")
                
        lightFolderPath = restoreBookmark(key: "LightModeFolderBookmark") ?? ""
        darkFolderPath = restoreBookmark(key: "DarkModeFolderBookmark") ?? ""
                
//        UserDefaults.standard.set(["en"], forKey: "AppleLanguages") // 测试英文样式
        // Terminal CMD:  defaults delete Tianlong-Yan.DarkLight-Wallpaper
        
    }

    func saveBookmark(for folderPath: String, key: String) {
        guard !folderPath.isEmpty else { return }
        let url = URL(fileURLWithPath: folderPath)
        do {
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: key)
        } catch {
            print("Failed to save bookmark: \(error)")
        }
    }


    func restoreBookmark(key: String) -> String? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            if isStale {
                // Bookmark data is stale, you might want to ask the user to choose the folder again
                print("Bookmark is stale")
                return nil
            }
            _ = url.startAccessingSecurityScopedResource()
            return url.path
        } catch {
            print("Failed to restore bookmark: \(error)")
            return nil
        }
    }
    
    // Manager
    
    private var timer: Timer?

    func setRandomWallpaper(_ lightFolderPath: String, _ darkFolderPath: String) {
        var folderPath: String
        let appearance = NSApp.effectiveAppearance
        let darkMode = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        
        if darkMode {
            folderPath = darkFolderPath
        } else {
            folderPath = lightFolderPath
        }
        
        guard !folderPath.isEmpty else { return }
        
        let url = URL(fileURLWithPath: folderPath)
        
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed to access folder \(url).")
            return
        }
        
        defer { url.stopAccessingSecurityScopedResource() }

        let fileManager = FileManager.default

        do {
            let files = try fileManager.contentsOfDirectory(atPath: folderPath)
            let imageFiles = files.filter { $0.lowercased().hasSuffix(".jpg") || $0.lowercased().hasSuffix(".png") || $0.lowercased().hasSuffix(".jpeg")}
            guard let randomFile = imageFiles.randomElement() else { return }
            let filePath = "\(folderPath)/\(randomFile)"
            try setDesktopWallpaper(filePath)
        } catch {
            print("Error setting wallpaper: \(error)")
        }
    }

    func updateTimer(interval: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { _ in
            self.setRandomWallpaper(self.lightFolderPath, self.darkFolderPath)
        }
    }
    
    func hideDockBarIcon(hideDockIcon: Bool) {
        if hideDockIcon {
            NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            NSApplication.shared.setActivationPolicy(NSApplication.ActivationPolicy.regular)
        }
    }
    
    func toggleAppearance() { // 只能切换此App的主题，不是整个系统的
        let appearance = NSApp.effectiveAppearance
        let isDarkMode = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        
        let script = """
        tell application "System Events"
            tell appearance preferences
                set dark mode to \(!isDarkMode)
            end tell
        end tell
        """
        
        // Check if Accessibility permissions are granted
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let isAccessibilityGranted = AXIsProcessTrustedWithOptions(options)
        
        if isAccessibilityGranted {
            let appleScript = NSAppleScript(source: script)
            var errorDict: NSDictionary?
            appleScript?.executeAndReturnError(&errorDict)

            if let error = errorDict {
                print("AppleScript error: \(error)")
            } else {
                print("Successfully changed system appearance to \(isDarkMode ? "light" : "dark") mode.")
            }
        } else {
            print("Accessibility permissions are not granted.")
        }
    }

    private func setDesktopWallpaper(_ filePath: String) throws {
        let url = URL(fileURLWithPath: filePath)
        
        if self.syncDisplay {
            NSScreen.screens.forEach({ (screen) in
                try? NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
            })
        } else {
            let screen = NSScreen.main
            try NSWorkspace.shared.setDesktopImageURL(url, for: screen!, options: [:])
        }
    }
}
