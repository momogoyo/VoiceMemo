//
//  DatePickerView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/12/25.
//

import SwiftUI

struct DatePickerView: View {
  @State var date: Date = Date()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 40) {
      VStack(alignment: .leading) {
        Text("날짜를 선택하세요")
          .font(.system(.title3, weight: .bold))
        
        DatePicker(
          "Select Date",
          selection: $date,
          displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
      }
      
      Divider()
      
      VStack(alignment: .leading) {
        Text("시간을 선택하세요")
          .font(.system(.title3, weight: .bold))
        
        DatePicker(
          "Select Time",
          selection: $date,
          displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.compact)
        .labelsHidden()
        .padding(.top, 10)
      }
      
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  DatePickerView()
}
