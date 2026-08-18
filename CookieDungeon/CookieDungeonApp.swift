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
        ImmersiveSpace(id: "room") {
            RoomView()
                .environment(appState)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        WindowGroup(id: "permission-denied") {
            PermissionRerequestView()
                .environment(appState)
        }
        .windowResizability(.contentSize)
    }
}
