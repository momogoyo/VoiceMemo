//
//  BorderedCaptionView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

struct BorderedCaptionView<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
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

#Preview {
  BorderedCaptionView(
    content: {
      Text("Green")
    }
  )
}
