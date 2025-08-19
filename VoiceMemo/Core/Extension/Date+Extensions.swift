//
//  Date+Extensions.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import Foundation

extension Date {
  var formattedTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "a hh:mm"
    
    return formatter.string(from: self)
  }
  
  var formattedDay: String {
    let now = Date()
    let calendar = Calendar.current
    
    let nowStartOfDay = calendar.startOfDay(for: now)
    let dateStartOfDay = calendar.startOfDay(for: self)
    let numOfDaysDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day
    
    if numOfDaysDifference == 0 {
      return "오늘"
    } else {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "MM월 dd일 E요일"
      return formatter.string(from: self)
    }
  }
  
  var formattedVoiceRecoderTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "yyyy.MM.dd"
    
    return formatter.string(from: self)
  }
}
