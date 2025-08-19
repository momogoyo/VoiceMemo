//
//  VoiceRecorderViewModel.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation
import AVFoundation

/// NSObjectProtocol보다 NSObject를 상속 받는게 더 간단하다.
/// Objective-C를 기반으로 만들어진 프로토콜은 NSObject를 기본 클래스(조상)를 기반으로 동작하기 때문에 채택해주어야 한다.
class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
  @Published var isDisplayRemoveVoiceRecorderAlert: Bool // 삭제할 때 나타나는 alert
  @Published var isDisplayAlert: Bool // 파일을 불러오거나, 녹음이 잘 안되는 등의 실패할 때 띄워줄 alert
  @Published var alertMessage: String
  
  /// 음성메모 녹음 관련 프로퍼티
  var audioRecorder: AVAudioRecorder?
  @Published var isRecording: Bool
  
  /// 음성메모 재생 관련 프로퍼티
  var audioPlayer: AVAudioPlayer?
  @Published var isPlaying: Bool
  @Published var isPaused: Bool
  @Published var playedTime: TimeInterval
  private var progressTimer: Timer?
  
  /// 음성메모 된 파일
  var recordedFiles: [URL] // 로컬로 저장되는 URL 타입
  
  /// 현재 선택된 음성메모 파일
  @Published var selectedRecorderFile: URL? // 없을수도 있으니 옵셔널 타입
  
  init(
    isDisplayRemoveVoiceRecorderAlert: Bool = false,
    isDisplayErrorAlert: Bool = false,
    errorAlertMessage: String = "",
    isRecording: Bool = false,
    audioPlayer: AVAudioPlayer? = nil,
    isPlaying: Bool = false,
    isPaused: Bool = false,
    playedTime: TimeInterval = 0,
    progressTimer: Timer? = nil,
    recordedFiles: [URL] = [],
    selectedRecorderFile: URL? = nil
  ) {
    self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
    self.isDisplayAlert = isDisplayErrorAlert
    self.alertMessage = errorAlertMessage
    self.isRecording = isRecording
    self.audioPlayer = audioPlayer
    self.isPlaying = isPlaying
    self.isPaused = isPaused
    self.playedTime = playedTime
    self.progressTimer = progressTimer
    self.recordedFiles = recordedFiles
    self.selectedRecorderFile = selectedRecorderFile
  }
}

// MARK: - 상태 값 및 사용자 인터렉션
extension VoiceRecorderViewModel {
  func voiceRecordCellTapped(_ recordedFile: URL) {
    if selectedRecorderFile != recordedFile {
      stopPlaying()
      selectedRecorderFile = recordedFile
    }
  }
  
  func removeButtonTapped() {
    setIsDisplayRemoveVoiceRecorderAlert(true)
  }
  
  func removeSelectedVoiceRecord() {
    guard let fileToRemove = selectedRecorderFile,
          let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
      // TODO: - 선택된 음성메모를 찾을 수 없다는 에러 Alert 노출
      displayAlert("선택된 음성메모를 찾을 수 없습니다.")
      return
    }
    
    do {
      /// removeItem(at: URL): 실제 파일/폴더를 삭제
      try FileManager.default.removeItem(at: fileToRemove)
      /// remove(at: 몇 번째 위치)
      recordedFiles.remove(at: indexToRemove)
      selectedRecorderFile = nil
      
      stopPlaying()
      
      displayAlert("선택된 음성메모를 삭제했습니다.")
    } catch {
      displayAlert("삭제 중에 오류가 발생했습니다.")
    }
  }
  
  // MARK: - 삭제 Alert 노출을 위한 상태 메서드
  private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
    isDisplayRemoveVoiceRecorderAlert = isDisplay
  }
  
  private func setErrorAlertMessage(_ message: String) {
    alertMessage = message
  }
  
  private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
    isDisplayAlert = isDisplay
  }
  
  private func displayAlert(_ message: String) {
    setErrorAlertMessage(message)
    setIsDisplayErrorAlert(true)
  }
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
  func recorderButtonTapped() {
    selectedRecorderFile = nil
    
    if isPlaying {
      stopPlaying()
      startRecording()
    } else if isRecording {
      stopRecording()
    } else {
      startRecording()
    }
  }
  
  private func startRecording() {
    /// requestRecordPermission: 마이크 권한 요청 팝업
    /// [weak self]: 메모리 누수 방지를 위한 약한 참조 - 뷰가 사라질 때 nil이 되어 같이 사라진다. (순환 참조 해결)
    /// granted: Bool 권한 허용 여부
    AVAudioApplication.requestRecordPermission { [weak self] granted in
      DispatchQueue.main.async {
        if granted {
          /// [weak self]이므로 옵셔널 체이닝
          self?.actualStartRecording()
        }
      }
    }
  }
  
  private func actualStartRecording() {
    do {
      /// AVAudioSession: 실제 오디오 환경 설정 - 앱이 어떻게 오디오를 사용할지 iOS에게 알려준다.
      let audioSession = AVAudioSession.sharedInstance()
      /// 어떤 오디오 기능을 쓸지 (재생및녹음, 일반모드, 스피커로 소리나도록 설정)
      try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
      /// 오디오 쓸 준비 완료
      try audioSession.setActive(true)
      
      let fileURL = getDocumentDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
      let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]
      
      /// AVAudioRecorder: 실제 녹음기 - 녹음 실행, 인코딩 및 저장
      audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
      audioRecorder?.record()
      self.isRecording = true
    } catch {
      displayAlert("음성메모 녹음 중 오류가 발생했습니다.")
    }
  }
  
  private func stopRecording() {
    audioRecorder?.stop()
    self.recordedFiles.append(audioRecorder!.url)
    self.isRecording = false
  }
  
  private func getDocumentDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}

// MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
  func startPlaying(recordedURL: URL) {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: recordedURL)
      audioPlayer?.delegate = self
      audioPlayer?.play()
      
      self.isPlaying = true
      self.isPaused = false
      self.progressTimer = Timer.scheduledTimer(
        withTimeInterval: 0.1,
        repeats: true
      ) { _ in
        self.updateCurrentTime()
      }
    } catch {
      displayAlert("음성메모 재생 중 오류가 발생했습니다.")
    }
  }
  
  private func updateCurrentTime() {
    self.playedTime = audioPlayer?.currentTime ?? 0
  }
  
  private func stopPlaying() {
    audioPlayer?.stop()
    self.playedTime = 0
    self.progressTimer?.invalidate()
    self.isPlaying = false
    self.isPaused = false
  }
  
  // 일시정지
  func pausePlaying() {
    audioPlayer?.pause()
    self.isPaused = true
  }
  
  // 재개
  func resumePlaying() {
    audioPlayer?.play()
    self.isPaused = false
  }
  
  // 음성메모 끝날 때까지 가서 완전히 끝
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.isPlaying = false
    self.isPaused = false
  }
  
  // 파일 정보 가져오기
  func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
    let fileManager = FileManager.default
    var creationDate: Date?
    var duration: TimeInterval?
    
    do {
      let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
      creationDate = fileAttributes[.creationDate] as? Date
    } catch {
      displayAlert("선택된 음성메모 파일 정보를 불러올 수 없습니다.")
    }
    
    do {
      let audioPlayer = try AVAudioPlayer(contentsOf: url)
      duration = audioPlayer.duration
    } catch {
      displayAlert("선택된 음성메모 파일의 재생시간을 불러올 수 없습니다.")
    }
    
    return (creationDate, duration)
  }
}
