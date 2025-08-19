//
//  CustomScrollView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

struct CustomScrollView: View {
  var body: some View {
    ScrollView(
      .vertical,
      showsIndicators: true
    ) {
      VStack {
        ForEach(0..<100) {
          Rectangle()
            .fill(
              Color(
                red: Double.random(in: 0...1),
                green: Double.random(in: 0...1),
                blue: Double.random(in: 0...1)
              )
            )
            .frame(width: .infinity, height: 50)
            .overlay(
              Text("Row \($0)")
                .font(.system(.body, weight: .bold))
                .foregroundStyle(.customSky)
            )
            .padding(.vertical, 4)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

#Preview {
  CustomScrollView()
}
