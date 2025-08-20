//
//  Time.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

struct Time {
  var hours: Int
  var minutes: Int
  var seconds: Int
  
  var convertSeconds: Int {
    return (hours * 3600) + (minutes * 60) + seconds
  }
  
  static func fromSeconds(_ seconds: Int) -> Time {
    let hours = seconds / 3600 // 초를 시간으로 변환
    let minutes = (seconds % 3600) / 60 // (시간을 제외한 나머지 초) / 나머지 초를 분으로 변환
    let remainingSeconds = (seconds % 3600) % 60 // (시간을 제외한 나머지 초) % 분을 제외한 나머지 초
    
    return Time(hours: hours, minutes: minutes, seconds: remainingSeconds)
  }
}
