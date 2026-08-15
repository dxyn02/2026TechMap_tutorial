//
//  ImmersiveView.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import ARKit
import RealityKit
import RealityKitContent
import SwiftUI

struct TutorialRoomView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        RealityView { content in
            async let creamSodaCookie = ModelEntity(named: "Cream_Soda_Cookie_Epic_Skin")
            
            if let creamSodaCookie = try? await creamSodaCookie {
                content.add(creamSodaCookie)
                
                creamSodaCookie.position = [0, 0, -6]
            }
        }
        .task {
            await appState.checkWorldSensingAuthorization()
            
            if appState.worldSensingAuthorizationStatus == .notDetermined {
                await appState.requestWorldSensingAuthorization()
            }
            
            if appState.worldSensingAuthorizationStatus == .denied {
                openWindow(id: "permission-denied")
            } else if appState.worldSensingAuthorizationStatus == .allowed {
                await appState.runARKitSession()
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    TutorialRoomView()
        .environment(AppState())
}
