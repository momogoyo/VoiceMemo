//
//  Notification.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/20/25.
//

import Foundation

/// request: 알림 요청 생성
/// trigger: 언제 알림을 발생할지 결정
/// NotificationCenter: 앱 내에서 이벤트를 통보하는데 사용 - 이벤트 관찰하다가 객체에게 알려주는 역할
/// 앱 내에서 여러 컴포넌트들 사이에서 비동기적으로 메시지를 전달하는 것

/// UNNotifiationCenter는 NotificationCenter의 일부로, 로컬 및 원격 푸시 알림을 관리한다. - 앱이 백그라운드에 있거나 종료된 상태여도 사용자에게 전달할 수 있다.
/// 시스템 레벨에서 메세지를 스케줄링하고 전달하는 것

// 어떠한 이벤트를 다루지만, 적용범위와 용도는 전혀 다르다.
