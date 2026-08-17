// AppState.swift

private func placeCookie(at position: SIMD3<Float>, for roomID: UUID) async {
    if let existingCookie = cookieEntities[roomID] {
        existingCookie.position = position
        
        return
    }
    
    guard let roomIndex = discoveredRoomIDs.firstIndex(of: roomID) else { return }
    
    let availableCookies = CookieModel.allCases
    let safeIndex = roomIndex % availableCookies.count
    
    let selectedCookie = availableCookies[safeIndex]
    
    do {
        let cookieEntity = try await ModelEntity(named: selectedCookie.filename)
        cookieEntity.position = position
        
        cookieEntities[roomID] = cookieEntity
        contentRoot.addChild(cookieEntity)
        
        print("\(roomIndex)번째 방에 \(selectedCookie.filename) 배치 완료")
    } catch {
        print("쿠키 불러오기 실패: \(error)")
    }
}
