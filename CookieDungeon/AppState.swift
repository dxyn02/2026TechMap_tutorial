//
//  AppState.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/14/26.
//

import ARKit
import RealityKit
import SwiftUI

@Observable
@MainActor
class AppState {
    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()
    private let roomTracking = RoomTrackingProvider()
    
    private var worldSensingAuthorizationStatus: ARKitSession.AuthorizationStatus = .notDetermined
    
    func requestWorldSensingAuthorization() async {
        let authorizationResult = await session.requestAuthorization(for: [.worldSensing])
        
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing] ?? .notDetermined
    }
    
    func checkWorldSensingAuthorization() async {
        let authorizationResult = await session.queryAuthorization(for: [.worldSensing])
        
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing] ?? .notDetermined
    }
    
    func runARKitSession() async {
        guard worldSensingAuthorizationStatus == .allowed else { return }
        
        do {
            try await session.run([worldTracking, roomTracking])
        } catch {
            print("ARKit 세션 실행 중 오류 발생: \(error)")
        }
    }
}
