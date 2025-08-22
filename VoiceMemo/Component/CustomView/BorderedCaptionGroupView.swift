//
//  WriteButton.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct BorderedCaptionGroupView: View {
  var body: some View {
    Text("Green")
      .modifier(BorderedCaptionViewModifier())
    
    Text("Green")
      .borderedCaption()
    
    
    Text("Blue")
      .borderdBlueCaption()
  }
}

#Preview {
  BorderedCaptionGroupView()
}
