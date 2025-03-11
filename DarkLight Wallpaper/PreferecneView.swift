//
//  PreferecneView.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import SwiftUI
import KeyboardShortcuts

struct PreferecneView: View {
    @StateObject private var wallpaperManager = AppState.wallpaperManager
    @Environment(\.colorScheme) var colorScheme
    private let selectFolderWidth: CGFloat = 200

    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            
            GroupBox(label: Label(NSLocalizedString("Current Theme", comment: ""), systemImage: "paintbrush").font(.headline)) {
                
                HStack(spacing: 10){
                    Text(colorScheme == .dark ? NSLocalizedString("Dark Theme", comment: "") : NSLocalizedString("Light Theme", comment: ""))
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .blue : .orange)
                    Spacer()
                    Image(systemName: colorScheme == .dark ? "moon.stars.fill" : "sun.max.fill")
                        .font(.system(size: 32))
                        .foregroundColor(colorScheme == .dark ? .blue : .orange)
                    
                }
                .padding()
                .onTapGesture {wallpaperManager.toggleAppearance()}
                
            }
            .padding()
            
            
            GroupBox(label: Label(NSLocalizedString("Select Wallpaper Folder", comment: ""), systemImage: "folder.fill").font(.headline)){
                VStack(alignment: .leading, spacing: 12){
                    HStack{
                        Text(NSLocalizedString("Light", comment: ""))
                        
                        Spacer()
                        
                        Button(wallpaperManager.lightFolderPath.isEmpty ? NSLocalizedString("Click to Select Folder", comment: "") : wallpaperManager.lightFolderPath) {
                            let panel = NSOpenPanel()
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            panel.begin { response in
                                if response == .OK, let url = panel.url {
                                    wallpaperManager.lightFolderPath = url.path
                                }
                            }
                        }
                        .lineLimit(1)
                        .truncationMode(.middle)
                        
                        Spacer()
                        
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                    }
        
                    HStack{
                        Text(NSLocalizedString("Dark", comment: ""))
                        
                        Spacer()
                        
                        Button(wallpaperManager.darkFolderPath.isEmpty ? NSLocalizedString("Click to Select Folder", comment: "") : wallpaperManager.darkFolderPath) {
                            let panel = NSOpenPanel()
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            panel.begin { response in
                                if response == .OK, let url = panel.url {
                                    wallpaperManager.darkFolderPath = url.path
                                }
                            }
                        }
                        .lineLimit(1)
                        .truncationMode(.middle)
                        
                        Spacer()
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }.padding()
            }
            .padding()
            
            GroupBox(label: Label(NSLocalizedString("Update Wallpaper", comment: ""), systemImage: "photo.fill").font(.headline)){
                VStack(alignment: .leading, spacing: 15){
                    HStack {
                        Text(NSLocalizedString("Update Interval", comment: ""))
                        Spacer()
                        TextField("1800", value: $wallpaperManager.refreshInterval, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text(NSLocalizedString("Second", comment: ""))
                    }
                    .onChange(of: wallpaperManager.refreshInterval) { oldInterval, newInterval in
                        wallpaperManager.updateTimer(interval: newInterval)}
                    HStack{
                        Button(action:{
                            wallpaperManager.setRandomWallpaper(wallpaperManager.lightFolderPath, wallpaperManager.darkFolderPath)
                        }){
                            Label(NSLocalizedString("Update Wallpaper Now", comment: ""), systemImage: "arrow.triangle.2.circlepath")
                        }
                        
                        Spacer()
                        KeyboardShortcuts.Recorder("", name: .switchWallpaper)
                    }
                }.padding()
            }
            .padding()
            
            GroupBox(label: Label(NSLocalizedString("Behavior", comment: ""), systemImage: "gearshape.fill").font(.headline)){
                VStack(alignment: .leading, spacing: 10){
                    Toggle(NSLocalizedString("Use the same wallpaper on all displays", comment: ""), isOn: $wallpaperManager.syncDisplay)
                    Toggle(NSLocalizedString("Hide Dock Bar Icon", comment: ""), isOn: $wallpaperManager.hideDockIcon)
                        .onChange(of: wallpaperManager.hideDockIcon) { oldHide, newHide in
                            wallpaperManager.hideDockBarIcon(hideDockIcon: newHide)}
                }.padding()
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: 500)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferecneView()
    }
}

//#Preview {
//    PreferecneView()
//        .environment(\.locale, .init(identifier: "en"))
//}
