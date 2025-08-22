//
//  View+Extensions.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

/// 뷰를 확장하고 그 안에 기능을 넣어주는 방식
extension View {
  func borderedCaption() -> some View {
    modifier(BorderedCaptionViewModifier())
  }
  
  /// ModifierView 채택 없이 내부에서 셀프에 속성 부여 후 새로운 View 반환
  func borderdBlueCaption() -> some View {
    self
      .font(.title)
      .padding(20)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(lineWidth: 3)
      )
      .foregroundColor(.blue)
  }
}
