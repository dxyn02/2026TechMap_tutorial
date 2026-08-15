//
//  ContentView.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct PermissionRerequestView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openURL) var openURL
    
    var body: some View {
        HStack (spacing: 40) {
            Model3D(named: "oven")
            
            VStack (spacing: 20) {
                Text("권한이 거부됨")
                    .font(.largeTitle)
                
                Text("앗! 오븐이 잠겨있어요.\n오븐에서 쿠키가 탈출할 수 있도록 권한을 허용해주세요.")
                    .multilineTextAlignment(.center)
                    
                Button("설정으로 이동하기") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }

            }
        }
        .padding(20)
    }
}

#Preview(windowStyle: .automatic) {
    PermissionRerequestView()
        .environment(AppState())
}
