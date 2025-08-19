//
//  ZStackAndOverlayView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

struct ZStackView: View {
  let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
  
  var body: some View {
    ZStack {
      ForEach(0..<colors.count, id: \.self) {
        Rectangle()
          .fill(colors[$0])
          .frame(width: 200, height: 200)
          .offset(
            x: CGFloat($0) * 10.0,
            y: CGFloat($0) * 10.0
          )
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.customBlack)
  }
}

struct OverlayView: View {
  var body: some View {
    ZStack {
      Rectangle()
        .fill(.customGreen)
        .frame(width: 100, height: 100)
        .cornerRadius(10)
        .offset(
          x: -40,
          y: -40
        )
        .zIndex(2)
      
      Rectangle()
        .fill(.yellow)
        .frame(width: 100, height: 100)
        .cornerRadius(10)
        .offset(
          x: 15,
          y: 15
        )
        .zIndex(1)
        .overlay(
          Rectangle()
            .fill(.blue)
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .offset(
              x: 30,
              y: 30
            )
          // overlay는 해당 Rectangle에 얹은거라 독립적으로 동작하지 않는다.
//            .zIndex(3)
        )
    }
    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
    .background(.customGray1)
  }
}

#Preview {
  VStack(spacing: 0) {
    ZStackView()
    OverlayView()
  }
  .edgesIgnoringSafeArea(.all)
}
