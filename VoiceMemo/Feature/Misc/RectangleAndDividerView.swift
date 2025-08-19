//
//  RectangleAndDivider.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

struct RectangleView: View {
  var body: some View {
    Rectangle()
      .fill(.pink)
      .frame(height: 30)
  }
}

struct DividerView: View {
  var body: some View {
    Divider()
      .frame(height: 30)
      .background(.purple)
  }
}

#Preview {
  VStack {
    RectangleView()
    DividerView()
  }
  .padding(.horizontal, 50)
}
