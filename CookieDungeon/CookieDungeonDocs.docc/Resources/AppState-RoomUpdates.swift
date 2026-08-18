// AppState.swift

func processRoomTrackingUpdates() async {
    for await update in roomTracking.anchorUpdates {
        let roomAnchor = update.anchor

        switch update.event {
        case .removed:
            roomAnchors.removeValue(forKey: roomAnchor.id)

            roomEntities[roomAnchor.id]?.removeFromParent()
            roomEntities.removeValue(forKey: roomAnchor.id)

            cookieEntities[roomAnchor.id]?.removeFromParent()
            cookieEntities.removeValue(forKey: roomAnchor.id)

        case .added, .updated:
            roomAnchors[roomAnchor.id] = roomAnchor

            if !discoveredRoomIDs.contains(roomAnchor.id) {
                discoveredRoomIDs.append(roomAnchor.id)
            }

            guard let roomMesh = roomAnchor.geometry.asMeshResource() else {
                continue
            }

            let bounds = roomMesh.bounds
            let localPosition = SIMD3<Float>(
                bounds.center.x,
                bounds.min.y + 0.1,
                bounds.center.z
            )
            let worldPosition = (
                roomAnchor.originFromAnchorTransform
                * SIMD4(localPosition, 1)
            ).xyz

            await placeCookie(at: worldPosition, for: roomAnchor.id)

            if update.event == .added {
                let roomEntity = ModelEntity(
                    mesh: roomMesh,
                    materials: [occlusionMaterial]
                )
                roomEntity.transform = Transform(
                    matrix: roomAnchor.originFromAnchorTransform
                )
                roomEntity.isEnabled = roomAnchor.isCurrentRoom
                roomEntities[roomAnchor.id] = roomEntity
                roomRoot.addChild(roomEntity)
            } else {
                guard let roomEntity = roomEntities[roomAnchor.id] else {
                    continue
                }
                roomEntity.model?.mesh = roomMesh
                roomEntity.transform = Transform(
                    matrix: roomAnchor.originFromAnchorTransform
                )
                roomEntity.isEnabled = roomAnchor.isCurrentRoom
            }
        }
    }
}
