# ``CookieDungeon``

visionOS 26에서 Room Tracking으로 방마다 다른 공간 콘텐츠를 구성합니다.

## Overview

Cookie Dungeon은 `RoomTrackingProvider`가 제공하는 방 경계와 현재 방 정보를 이용해, 발견된 방마다 서로 다른 USDZ 쿠키를 배치하는 Apple Vision Pro 예제입니다.

튜토리얼에서는 다음 내용을 하나의 구현 흐름으로 학습합니다.

- `ARKitSession`, Provider, Anchor의 역할과 데이터 흐름
- World Sensing 권한 선언·조회·요청
- `RealityView`와 생성 클로저의 `content`가 Entity를 구성하는 방식
- `RoomAnchor.geometry`를 RealityKit 메시로 변환하는 방법
- `OcclusionMaterial`로 현실 벽 뒤의 가상 객체를 가리는 원리
- `RoomAnchor.id`와 발견 순서를 사용한 방별 쿠키 선택

> Important: Room Tracking은 실제 공간 데이터에 의존합니다. 문서 빌드는 Mac에서 할 수 있지만, 방 전환과 오클루전의 최종 동작은 Apple Vision Pro에서 확인하세요.

## Topics

### Tutorial

- <doc:TableOfContents>
- <doc:RoomTracking>
