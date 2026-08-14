//
//  ImmersiveView.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            async let creamSodaCookie = ModelEntity(named: "Cream_Soda_Cookie_Epic_Skin")
            
            if let creamSodaCookie = try? await creamSodaCookie {
                content.add(creamSodaCookie)
                
                creamSodaCookie.position = [0, 0, -6]
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
