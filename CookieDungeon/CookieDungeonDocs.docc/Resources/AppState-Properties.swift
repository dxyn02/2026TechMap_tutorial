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
    
    // 쿠키 콘텐츠의 루트
    let contentRoot = Entity()
    // 오클루전용 방 지오메트리의 루트
    let roomRoot = Entity()
    
    private var roomAnchors = [UUID: RoomAnchor]()
    private var cookieEntities = [UUID: ModelEntity]()
    private var roomEntities = [UUID: ModelEntity]()
    
    private var discoveredRoomIDs: [UUID] = []
    
    private let occlusionMaterial = OcclusionMaterial()
    
    // 메서드 생략
}
