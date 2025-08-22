//
//  BorderedCaption.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

struct BorderedCaptionViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.title)
      .padding(20)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(lineWidth: 3)
      )
      .foregroundColor(.green)
  }
}
