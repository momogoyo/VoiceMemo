//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
  
  /// @UIApplicationDelegateAdaptor: SwiftUI에서 UIKit의 UIApplicationDelegate를 생성하는데 사용하는 프로퍼티 래퍼
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      OnboardingView()
    }
  }
}
