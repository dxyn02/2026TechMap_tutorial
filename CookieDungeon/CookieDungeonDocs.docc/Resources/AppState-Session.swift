// AppState.swift

func runARKitSession() async {
    guard worldSensingAuthorizationStatus == .allowed else {
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
