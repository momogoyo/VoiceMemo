//
//  WirteButton.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/22/25.
//

import SwiftUI

// MARK: - 1. ViewModifier 채택해서 modifier() 이용하는 방법
public struct WriteButtonViewModifier: ViewModifier {
  let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      content
      
      VStack {
        Spacer()
        
        HStack {
          Spacer()
          
          Button(
            action: action,
            label: {
              Image("writeBtn")
            }
          )
        }
      }
      .padding(.trailing, 20)
      .padding(.bottom, 50)
    }
  }
}

// MARK: - 2. View 확장하기
extension View {
  public func writeButton(action: @escaping () -> Void) -> some View {
    modifier(WriteButtonViewModifier(action: action))
  }
}

// MARK: - 3. 새로운 View 창조하기
public struct WriteBtnView<Content: View>: View {
  let content: Content
  let action: () -> Void
  
  public init(
    @ViewBuilder content: () -> Content,
    action: @escaping () -> Void
  ) {
    self.content = content()
    self.action = action
  }
  
  public var body: some View {
    ZStack {
      content
      
      VStack {
        Spacer()
        
        HStack {
          Spacer()
          
          Button(
            action: action,
            label: {
              Image("writeBtn")
            }
          )
        }
      }
      .padding(.trailing, 20)
      .padding(.bottom, 50)
    }
  }
}
