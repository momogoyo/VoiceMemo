//
//  Memo.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

struct Memo: Hashable {
  var id: UUID = UUID()
  var title: String
  var content: String
  var date: Date
  
  var convertedDayAndTime: String {
    String("\(date.formattedDay) - \(date.formattedTime)")
  }
}
