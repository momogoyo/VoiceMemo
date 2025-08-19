//
//  CustomDividerView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/14/25.
//

import SwiftUI

struct CustomDividerView: View {
  let fillColor: Color
  
  init(_ fillColor: Color = .customGray0) {
    self.fillColor = fillColor
  }
  
  var body: some View {
    Rectangle()
      .fill(fillColor)
      .frame(height: 1)
    
  }
}

#Preview {
  CustomDividerView(.customGray0)
}
