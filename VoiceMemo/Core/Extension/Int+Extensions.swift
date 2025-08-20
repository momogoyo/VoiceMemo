//
//  Int+Extensions.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/19/25.
//

import Foundation

extension Int {
  var formattedTime: String {
    let time = Time.fromSeconds(self)
    
    let hoursString = String(format: "%02d", time.hours)
    let minutesString = String(format: "%02d", time.minutes)
    let secondsString = String(format: "%02d", time.seconds)
    
    return "\(hoursString) : \(minutesString) : \(secondsString)"
  }
  
  /// 지금부터 N초 후의 시간을 HH:mm 형식으로 보여주는 함수
  var formattedSettingTime: String {
    let currentDate = Date()
    let settingDate = currentDate.addingTimeInterval(TimeInterval(self))
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: settingDate)
  }
}
