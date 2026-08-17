// AppState.swift

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
