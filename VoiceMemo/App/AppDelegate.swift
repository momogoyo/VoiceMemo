//
//  AppDelegate.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  var notificationDelegate = NotificationDelegate()
  
  /// UIApplicationDelegate를 상속 받았기 때문에 didFinishLaunchingWithOptions을 사용할 수 있다.
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    print("VoiceMemo App is running")
    UNUserNotificationCenter.current().delegate = notificationDelegate
    
    return true
  }
}
