//
//  Notification.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/20/25.
//

import Foundation
import UserNotifications

/// NotificationCenter vs. UNUserNotificationCenter - 둘다 어떠한 이벤트를 다루는지만, 적용범위와 용도는 전혀 다르다.
/// 1. NotificationCenter: 앱 내부에서 컴포넌트 간 메세지 전달 역할
/// 앱이 실행되고 있을 때만 작동
///
/// 2. UNUserNotificationCenter: 시스템 레벨의 알림 매니저
/// 사용자에게 직접 노출되는 알림 (상단 배너, 잠금 알림 등)
/// 앱이 종료된 상태나 백그라운드 상태일 때도 동작

struct NotificationService {
  func sendNotification() {
    /// 1단계: 권한 요청
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .sound, .badge]
    ) { granted, error in
      if let error = error {
        print("권한 요청 에러: \(error)")
        return
      }
      
      if granted {
        /// 2단계: 알림 내용 만들기
        let content = UNMutableNotificationContent()
        content.title = "타이머 종료"
        content.body = "설정한 타이머가 종료되었습니다."
        content.sound = UNNotificationSound.default
        
        /// 3단계: 언제보낼지 정하기 - trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        /// 4단계: 요청서 만들기 - request
        let request = UNNotificationRequest(
          identifier: UUID().uuidString,
          content: content,
          trigger: trigger
        )
        /// 5단계: 시스템에게 알림 예약 요청
        UNUserNotificationCenter.current().add(request)
      }
    }
  }
}

/// UNUserNotificationCenterDelegate: 알림이 왔을 때 어떤식으로 보여줄지/반응할지 정해주는 역할
/// banner와 sound로 보여준다는 등
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) -> Void {
    completionHandler([.banner, .sound])
  }
}
