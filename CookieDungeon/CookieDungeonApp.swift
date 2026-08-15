//
//  CookieDungeonApp.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import SwiftUI

@main
struct CookieDungeonApp: App {

    @State private var appState = AppState()

    var body: some Scene {
        ImmersiveSpace(id: "tutorial-room") {
            TutorialRoomView()
                .environment(appState)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        WindowGroup(id: "permission-denied") {
            PermissionRerequestView()
                .environment(appState)
                .frame(minWidth: 1000, maxWidth: 1500, minHeight: 400, maxHeight: 600)
        }
        .defaultSize(width: 1000, height: 600)
        .windowResizability(.contentSize)
    }
}
