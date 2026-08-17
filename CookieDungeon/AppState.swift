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
    let contentRoot = Entity()
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
    
    func processRoomTrackingUpdates() async {
        for await update in roomTracking.anchorUpdates {
            let roomAnchor = update.anchor
            
            let centerPosition = roomAnchor.originFromAnchorTransform.columns.3.xyz
            
            switch update.event {
            case .removed:
                roomAnchors.removeValue(forKey: roomAnchor.id)
                roomEntities[roomAnchor.id]?.removeFromParent()
                roomEntities.removeValue(forKey: roomAnchor.id)
                
                cookieEntities[roomAnchor.id]?.removeFromParent()
                cookieEntities.removeValue(forKey: roomAnchor.id)
                
            case .added, .updated:
                roomAnchors[roomAnchor.id] = roomAnchor
                
                await placeCookie(at: centerPosition, for: roomAnchor.id)
                
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
    
    private func placeCookie(at position: SIMD3<Float>, for roomID: UUID) async {
        if let existingCookie = cookieEntities[roomID] {
            existingCookie.position = position
            
            return
        }
        
        do {
            let cookie = try await ModelEntity(named: "Cream_Soda_Cookie_Epic_Skin")
            cookie.position = position
            
            cookieEntities[roomID] = cookie
            contentRoot.addChild(cookie)
            
            print("쿠키 배치 완료")
        } catch {
            print("쿠키 불러오기 실패: \(error)")
        }
    }
}
