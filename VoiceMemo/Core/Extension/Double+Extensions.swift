//
//  Double+Extensions.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/17/25.
//

import Foundation

// 03:35:45

extension Double {
  var formatterTimeInterval: String {
    let totalSeconds = Int(self)
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60 % 60
  
    /// %: 포맷 지시자
    /// 0: 빈공간은 0으로 표시
    /// 2: 최소 2자리 수
    /// d: 정수타입
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
