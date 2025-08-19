//
//  LoginView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

enum Field {
  case name
  case password
}

struct LoginView: View {
  @State var name: String = ""
  @State var password: String = ""
  @FocusState var focusField: Field?
  
  var body: some View {
    Form {
      TextField(
        "Name",
        text: $name
      )
      .focused($focusField, equals: .name)
      .onSubmit {
        focusField = .password
      }
      
      SecureField(
        "Password",
        text: $password
      )
      .focused($focusField, equals: .password)
      .onSubmit {
        checkTextField()
      }
      
      Button("Login") {
        checkTextField()
      }
    }
    .onAppear {
      focusField = .name
    }
  }
}

extension LoginView {
  private func checkTextField() {
    if name.isEmpty {
      focusField = .name
    } else if password.isEmpty {
      focusField = .password
    } else {
      focusField = nil
    }
  }
}

#Preview {
  LoginView()
}
