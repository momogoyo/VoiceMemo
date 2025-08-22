//
//  VoiceRecorderView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct VoiceRecorderView: View {
  @StateObject private var voiceRecorderViewModel: VoiceRecorderViewModel = VoiceRecorderViewModel()
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    ZStack {
      VStack {
        TitleView()
        
        if voiceRecorderViewModel.recordedFiles.isEmpty {
          AnnouncementView()
        } else {
          VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
            .padding(.top, 15)
        }
        
        Spacer()
      }
      
      RecordButton(voiceRecorderViewModel: voiceRecorderViewModel)
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
    .alert(
      "선택된 음성메모를 삭제하시겠습니까?",
      isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
    ) {
      Button("삭제", role: .destructive) {
        voiceRecorderViewModel.removeSelectedVoiceRecord()
      }
      Button("취소", role: .cancel) { }
    }
    .alert(
      voiceRecorderViewModel.alertMessage,
      isPresented: $voiceRecorderViewModel.isDisplayAlert
    ) {
      Button("확인", role: .cancel) { }
    }
    .onChange(of: voiceRecorderViewModel.recordedFiles) { _, recordedFiles in
      homeViewModel.setVoiceRecordersCount(recordedFiles.count)
    }
  }
}

private struct TitleView: View {
  fileprivate var body: some View {
    HStack {
      Text("음성메모")
        .font(.system(size: 30, weight: .bold))
        .foregroundColor(.customBlack)
      
      Spacer()
    }
    .padding(.horizontal, 30)
    .padding(.top, 30)
  }
}

private struct AnnouncementView: View {
  fileprivate var body: some View {
    VStack(spacing: 15) {
      CustomDividerView(.customCoolGray)
      
      Spacer()
        .frame(height: 180)
      
      Image("pencil")
        .renderingMode(.template)
      Text("현재 등록된 음성메모가 없습니다.")
      Text("하단의 녹음버튼을 눌러 음성메모를 시작해주세요.")
      
      Spacer()
    }
    .font(.system(size: 16))
    .foregroundColor(.customGray2)
  }
}

private struct VoiceRecorderListView: View {
  @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
  
  fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
    self.voiceRecorderViewModel = voiceRecorderViewModel
  }
  
  fileprivate var body: some View {
    ScrollView(.vertical) {
      VStack {
        CustomDividerView()
        
        ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
          VoiceRecorderCellView(
            voiceRecorderViewModel: voiceRecorderViewModel,
            recordedFile: recordedFile
          )
        }
      }
    }
  }
}

private struct VoiceRecorderCellView: View {
  @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
  private var recordedFile: URL
  private var creationDate: Date?
  private var duration: TimeInterval?
  
  private var progressBarValue: Float {
    if (voiceRecorderViewModel.selectedRecorderFile == recordedFile) && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
      return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
    } else {
      return 0
    }
  }
  
  private var isPlaying: Bool {
    return (voiceRecorderViewModel.selectedRecorderFile == recordedFile) && (voiceRecorderViewModel.isPlaying && !voiceRecorderViewModel.isPaused)
  }
  
  fileprivate init(
    voiceRecorderViewModel: VoiceRecorderViewModel,
    recordedFile: URL
  ) {
    self.voiceRecorderViewModel = voiceRecorderViewModel
    self.recordedFile = recordedFile
    (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
  }
  
  fileprivate var body: some View {
    VStack {
      Button(
        action: {
          voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
        },
        label: {
          VStack(alignment: .leading) {
            HStack {
              /// lastPathComponent: 파일 경로의 가장 마지막 이름을 가져오는 메서드
              Text(recordedFile.lastPathComponent)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.customBlack)
              
              Spacer()
            }
            
            Spacer()
              .frame(height: 5)
            
            HStack {
              if let creationDate = creationDate {
                Text(creationDate.formattedVoiceRecoderTime)
                  .font(.system(size: 14))
                  .foregroundColor(.customIconGray)
              }
              
              Spacer()
              
              if let duration = duration {
                Text(duration.formatterTimeInterval)
                  .font(.system(size: 14))
                  .foregroundColor(.customIconGray)
              }
            }
          }
        }
      )
      .padding(.horizontal, 20)
      
      if voiceRecorderViewModel.selectedRecorderFile == recordedFile {
        VStack {
          // TODO: - 프로그래스 바
          ProgressBar(progress: progressBarValue)
          
          Spacer()
            .frame(height: 5)
          
          HStack {
            Text(voiceRecorderViewModel.playedTime.formatterTimeInterval)
              .font(.system(size: 10, weight: .medium))
              .foregroundColor(.customIconGray)
            
            Spacer()
            
            if let duration = duration {
              Text(duration.formatterTimeInterval)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.customIconGray)
            }
          }
          
          Spacer()
            .frame(height: 10)
          
          HStack {
            Spacer()
            
            Button(
              action: {
                if voiceRecorderViewModel.isPaused {
                  voiceRecorderViewModel.resumePlaying()
                } else if voiceRecorderViewModel.isPlaying {
                  voiceRecorderViewModel.pausePlaying()
                } else {
                  voiceRecorderViewModel.startPlaying(recordedURL: recordedFile)
                }
              },
              label: {
                if isPlaying {
                  Image("pause")
                    .renderingMode(.template)
                    .foregroundColor(.customBlack)
                } else {
                  Image("play")
                    .renderingMode(.template)
                    .foregroundColor(.customBlack)
                }
              }
            )
              
            Spacer()
            
            Button(
              action: {
                voiceRecorderViewModel.removeButtonTapped()
              },
              label: {
                Image("trash")
                  .renderingMode(.template)
                  .frame(width: 30, height: 30)
                  .foregroundColor(.customBlack)
              }
            )
          }
        }
        .padding(.horizontal, 20)
      }
      
      CustomDividerView()
    }
  }
}

private struct ProgressBar: View {
  private var progress: Float
  
  fileprivate init(progress: Float = 0.0) {
    self.progress = progress
  }
  
  fileprivate var body: some View {
    GeometryReader { geometryReader in
      ZStack(alignment: .leading) {
        Rectangle()
          .fill(.customGray2)
          .frame(height: 3)
        
        Rectangle()
          .fill(.customGreen)
          .frame(width: CGFloat(self.progress) * geometryReader.size.width)
      }
    }
  }
}

private struct RecordButton: View {
  @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
  @State private var isAnimation: Bool
  
  fileprivate init(
    voiceRecorderViewModel: VoiceRecorderViewModel,
    isAnimation: Bool = false
  ) {
    self.voiceRecorderViewModel = voiceRecorderViewModel
    self.isAnimation = isAnimation
  }
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Spacer()
        
        Button(
          action: {
            voiceRecorderViewModel.recorderButtonTapped()
          },
          label: {
            if voiceRecorderViewModel.isRecording {
              Image("mic_recording")
                .scaleEffect(isAnimation ? 1.5 : 1)
                .onAppear {
                  withAnimation(.spring().repeatForever()) {
                    isAnimation.toggle()
                  }
                }
                .onDisappear {
                  isAnimation = false
                }
            } else {
              Image("mic")
            }
          }
        )
      }
    }
  }
}

#Preview {
  VoiceRecorderView()
}
