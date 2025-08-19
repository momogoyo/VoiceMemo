//
//  TodoViewModel.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

class TodoViewModel: ObservableObject {
  @Published var title: String
  @Published var time: Date
  @Published var day: Date
  @Published var isDisplayCalendar: Bool
  
  init(
    title: String = "",
    time: Date = Date(),
    day: Date = Date(),
    isDisplayCalendar: Bool = false
  ) {
    self.title = title
    self.time = time
    self.day = day
    self.isDisplayCalendar = isDisplayCalendar
  }
}

extension TodoViewModel {
  func setDisplayCalendar(_ isDisplay: Bool) {
    isDisplayCalendar = isDisplay
  }
}
