//
//  ContentView.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import ARKit
import RealityKit
import RealityKitContent
import SwiftUI

struct PermissionRerequestView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openURL) var openURL
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
        HStack (spacing: 40) {
            Model3D(named: "oven") { phase in
                switch phase {
                case .empty:
                    VStack (alignment: .center, spacing: 20) {
                        Text("로딩 중")
                            .font(.largeTitle)
                        ProgressView()
                    }
                case .failure(let error):
                    Text("오류 발생: \(error.localizedDescription)")
                case .success(let model):
                    model.resizable()
                @unknown default:
                    Text("알 수 없는 오류 발생")
                }
            }
            
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
        .task {
            await appState.checkWorldSensingAuthorization()
            
            if appState.worldSensingAuthorizationStatus == .notDetermined {
                await appState.requestWorldSensingAuthorization()
            }
            
            if appState.worldSensingAuthorizationStatus == .denied {
                return
            } else if appState.worldSensingAuthorizationStatus == .allowed {
                await openImmersiveSpace(id: "tutorial-room")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    PermissionRerequestView()
        .environment(AppState())
}
