//
//  TimerView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct TimerView: View {
  @StateObject var timerViewModel: TimerViewModel = TimerViewModel()
  
  var body: some View {
    ZStack {
      if timerViewModel.isDisplaySetTimeView {
        // TODO: - 타이머 설정 뷰
        SetTimerView(timerViewModel: timerViewModel)
      } else {
        // TODO: - 타이머 작동 뷰
        TimerOperationView(timerViewModel: timerViewModel)
      }
    }
  }
}

private struct SetTimerView: View {
  @ObservedObject private var timerViewModel: TimerViewModel
  
  fileprivate init(timerViewModel: TimerViewModel) {
    self.timerViewModel = timerViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      TimerTitleView()
      
      Spacer()
        .frame(height: 50)
      
      TimerPicerView(timerViewModel: timerViewModel)
      
      Spacer()
        .frame(height: 30)
      
      TimerCreateButtonView(timerViewModel: timerViewModel)
      
      Spacer()
    }
  }
}

// MARK: - 타이머 타이틀 뷰
private struct TimerTitleView: View {
  fileprivate var body: some View {
    HStack {
      Text("타이머")
        .font(.system(size: 30, weight: .bold))
        .foregroundColor(.customBlack)
      
      Spacer()
    }
    .padding(.horizontal, 30)
    .padding(.top, 30)
  }
}

// MARK: - 타이머 피커 뷰
private struct TimerPicerView: View {
  @ObservedObject private var timerViewModel: TimerViewModel
  
  fileprivate init(timerViewModel: TimerViewModel) {
    self.timerViewModel = timerViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      CustomDividerView()
      
      HStack {
        Picker("Hours", selection: $timerViewModel.time.hours) {
          ForEach(0..<24) { hour in
            Text("\(hour)시간")
          }
        }
        
        Picker("Minutes", selection: $timerViewModel.time.minutes) {
          ForEach(0..<60) { minute in
            Text("\(minute)분")
          }
        }
        
        Picker("Seconds", selection: $timerViewModel.time.seconds) {
          ForEach(0..<60) { second in
            Text("\(second)초")
          }
        }
      }
      .labelsHidden()
      .pickerStyle(.wheel)
      
      CustomDividerView()
    }
  }
}

private struct TimerCreateButtonView: View {
  @ObservedObject private var timerViewModel: TimerViewModel
  
  fileprivate init(timerViewModel: TimerViewModel) {
    self.timerViewModel = timerViewModel
  }
  
  fileprivate var body: some View {
    Button(
      action: {
        timerViewModel.setTimeButtonTapped()
      },
      label: {
        Text("설정하기")
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(.customGreen)
      }
    )
  }
}

// MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {
  @ObservedObject private var timerViewModel: TimerViewModel
  
  fileprivate init(timerViewModel: TimerViewModel) {
    self.timerViewModel = timerViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      ZStack {
        VStack {
          Text("\(timerViewModel.timeRemaining.formattedTime)")
            .font(.system(size: 28, weight: .regular))
            .foregroundColor(.customIconGray)
            .monospaced()
          
          HStack(alignment: .bottom) {
            Image(systemName: "bell.fill")
              .renderingMode(.template)
              .foregroundColor(.customIconGray)
            
            Text("\(timerViewModel.time.convertSeconds.formattedSettingTime)")
              .font(.system(size: 16, weight: .medium))
              .foregroundStyle(.customIconGray)
              .padding(.top, 10)
          }
        }
        
        Circle()
          .stroke(Color.customOrange, lineWidth: 6)
          .frame(width: 350)
      }
      
      Spacer()
        .frame(height: 10)
      
      HStack {
        Button(
          action: {
            timerViewModel.cancelButtonTapped()
          },
          label: {
            Text("취소")
              .font(.system(size: 16))
              .foregroundColor(.customIconGray)
              .padding(.vertical, 25)
              .padding(.horizontal, 22)
              .background(
                Circle()
                  .fill(.customGray2.opacity(0.3))
              )
          }
        )
        
        Spacer()
        
        Button(
          action: {
            timerViewModel.pauseOrRestartButtonTapped()
          },
          label: {
            Text(timerViewModel.isPaused ? "계속 진행" : "일시 정지")
              .font(.system(size: 14))
              .foregroundColor(.customIconGray)
              .padding(.vertical, 25)
              .padding(.horizontal, 7)
              .background(
                Circle()
                  .fill(.customOrange.opacity(0.3))
              )
          }
        )
      }
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  TimerView()
}
