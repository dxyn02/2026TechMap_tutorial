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
    
    private(set) var worldSensingAuthorizationStatus: ARKitSession.AuthorizationStatus = .notDetermined
    
    // 모든 가상 콘텐츠의 루트
    private let contentRoot = Entity()
    // 방 범위 지오메트리의 루트
    private let roomRoot = Entity()
    
    private var roomAnchors = [UUID: RoomAnchor]()
    private var worldAnchors = [UUID: WorldAnchor]()
    private var cookieEntities = [UUID: ModelEntity]()
    private var roomEntities = [UUID: ModelEntity]()
    
    private let occlusionMaterial = OcclusionMaterial()
    
    private var currentRoomID: UUID?
    
    func requestWorldSensingAuthorization() async {
        let authorizationResult = await session.requestAuthorization(for: [.worldSensing])
        
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing] ?? .notDetermined
    }
    
    func checkWorldSensingAuthorization() async {
        let authorizationResult = await session.queryAuthorization(for: [.worldSensing])
        
        worldSensingAuthorizationStatus = authorizationResult[.worldSensing] ?? .notDetermined
    }
    
    func runARKitSession() async {
        guard worldSensingAuthorizationStatus == .allowed else {
            print("worldSending 권한 없음")
            
            return
        }
        
        do {
            try await session.run([worldTracking, roomTracking])
            
            Task {
                await processRoomTrackingUpdates()
            }
            
        } catch {
            print("ARKit 세션 실행 중 오류 발생: \(error)")
        }
    }
    
    // 해당 부분 추가 학습 필요: AnchorUpdate<RoomAnchor>.event & RoomTrackingProvider.anchorUpdates.anchor
    func processRoomTrackingUpdates() async {
        for await update in roomTracking.anchorUpdates {
            let roomAnchor = update.anchor
            
            switch update.event {
            case .removed:
                roomAnchors.removeValue(forKey: roomAnchor.id)
                roomEntities[roomAnchor.id]?.removeFromParent()
                roomEntities.removeValue(forKey: roomAnchor.id)
                
            case .added, .updated:
                roomAnchors[roomAnchor.id] = roomAnchor
                guard let roomMeshResource = roomAnchor.geometry.asMeshResource() else { continue }
                
                if update.event == .added {
                    let roomEntity = ModelEntity(mesh: roomMeshResource, materials: [occlusionMaterial])
                    roomEntity.transform = Transform(matrix: roomAnchor.originFromAnchorTransform)
                    roomEntities[roomAnchor.id] = roomEntity
                    roomEntity.isEnabled = roomAnchor.isCurrentRoom
                    roomRoot.addChild(roomEntity)
                } else if update.event == .updated {
                    guard let roomEntity = roomEntities[roomAnchor.id] else { continue }
                    roomEntity.model?.mesh = roomMeshResource
                    roomEntity.transform = Transform(matrix: roomAnchor.originFromAnchorTransform)
                    roomEntity.isEnabled = roomAnchor.isCurrentRoom
                }
                
                if roomAnchor.isCurrentRoom {
                    currentRoomID = roomAnchor.id
                }
            }
        }
    }
}
