//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

class TimerViewModel: ObservableObject {
  @Published var isDisplaySetTimeView: Bool
  @Published var time: Time
  @Published var timer: Timer?
  @Published var timeRemaining: Int
  @Published var isPaused: Bool
  
  init(
    isDisplaySetTimeView: Bool = true,
    time: Time = .init(hours: 0, minutes: 0, seconds: 0),
    timer: Timer? = nil,
    timeRemaining: Int = 0,
    isPaused: Bool = false
  ) {
    self.isDisplaySetTimeView = isDisplaySetTimeView
    self.time = time
    self.timer = timer
    self.timeRemaining = timeRemaining
    self.isPaused = isPaused
  }
}

extension TimerViewModel {
  // MARK: - 설정하기 버튼
  func setTimeButtonTapped() {
    isDisplaySetTimeView = false
    timeRemaining = time.convertSeconds
  
    startTimer()
  }
  
  // MARK: - 취소하기 버튼
  func cancelButtonTapped() {
    isDisplaySetTimeView = true
  
    stopTimer()
  }
  
  // MARK: - 타이머 재개, 멈춤 버튼
  func pauseOrRestartButtonTapped() {
    if isPaused {
      startTimer()
    } else {
      timer?.invalidate()
      timer = nil
    }
    
    isPaused.toggle()
  }
}

private extension TimerViewModel {
  func startTimer() {
    guard timer == nil else { return }
    
    timer = Timer.scheduledTimer(
      withTimeInterval: 1, /// 1초를 기준으로 타이머 설정
      repeats: true
    ) { _ in
      if self.timeRemaining > 0 {
        /// 시간이 남았다면 1초씩 감소
        self.timeRemaining -= 1
      } else {
        /// 타이머 정지
        self.stopTimer()
      }
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
}
