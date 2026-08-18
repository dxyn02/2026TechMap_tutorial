// AppState.swift

private(set) var worldSensingAuthorizationStatus:
    ARKitSession.AuthorizationStatus = .notDetermined

func checkWorldSensingAuthorization() async {
    let result = await session.queryAuthorization(for: [.worldSensing])
    worldSensingAuthorizationStatus = result[.worldSensing] ?? .notDetermined
}

func requestWorldSensingAuthorization() async {
    let result = await session.requestAuthorization(for: [.worldSensing])
    worldSensingAuthorizationStatus = result[.worldSensing] ?? .notDetermined
}
