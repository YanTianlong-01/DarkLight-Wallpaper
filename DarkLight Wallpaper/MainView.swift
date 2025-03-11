//
//  MainView.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/8.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            VStack{
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .frame(width: 128, height: 128)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text("DarkLight Wallpaper for Mac")
                    .font(.largeTitle)
            }
            .padding()
            
            HStack{
                Text(NSLocalizedString("Click the App icon on the status bar to access the preference", comment: ""))
                
                Button(NSLocalizedString("Preference", comment: "")){
                    AppState.preferencesWindow.makeKeyAndOrderFront(nil)
                    NSApp.activate(ignoringOtherApps: true)
                }
                    
            }.padding()
            
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
