//
//  AlertView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

struct Info {
  let name: String
  let message: String
}

struct AlertView: View {
  @State private var isDisplayAlert: Bool = false
  @State private var info: Info?
  
  var body: some View {
    Button("Save") {
      info = .init(name: "Info", message: "Fail to save")
      isDisplayAlert = true
    }
    .alert(
      "An error occured",
      isPresented: $isDisplayAlert,
      presenting: info // 넘겨줄 데이터
    ) { info in
      Button(role: .destructive) {
        
      } label: {
        Text("Delete \(info.name)")
      }
    } message: { info in
      Text(info.message)
    }
  }
}

#Preview {
  AlertView()
}
