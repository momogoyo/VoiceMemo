//
//  ContentView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct OnboardingView: View {
  @StateObject private var pathModel = PathModel()
  @StateObject private var onboardingViewModel = OnboardingViewModel()
  @StateObject private var todoListViewModel = TodoListViewModel()
  @StateObject private var memoListViewModel = MemoListViewModel()
  @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
  
  var body: some View {
    // MARK: - 화면 전환
    NavigationStack(path: $pathModel.paths) {
      //      OnboardingContentView(onboardingViewModel: onboardingViewModel)
      //      TodoListView()
      //        .environmentObject(todoListViewModel)
      //      MemoListView()
      //        .environmentObject(memoListViewModel)
      //      VoiceRecorderView()
      //        .environmentObject(voiceRecorderViewModel)
//      TimerView()
      SettingsView()
        .navigationDestination(
          for: PathType.self,
          destination: { pathType in
            switch pathType {
            case .homeView:
              HomeView()
                .navigationBarBackButtonHidden()
            case .todoView:
              TodoView()
                .navigationBarBackButtonHidden()
                .environmentObject(todoListViewModel)
            case let .memoView(isCreateMode, memo):
              MemoView(
                memoViewModel: isCreateMode
                ? .init(memo: .init(title: "", content: "", date: .now))
                : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                isCreateMode: isCreateMode
              )
              .navigationBarBackButtonHidden()
              .environmentObject(memoListViewModel)
            }
          }
        )
    }
    .environmentObject(pathModel)
  }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel
  
  fileprivate init(onboardingViewModel: OnboardingViewModel) {
    self.onboardingViewModel = onboardingViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      OnboardingCellListView(onboardingViewModel: onboardingViewModel)
      
      Spacer()
      
      StartButtonView()
    }
    .edgesIgnoringSafeArea(.top)
  }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
  @ObservedObject private var onboardingViewModel: OnboardingViewModel
  @State var selectedIndex: Int
  
  fileprivate init(onboardingViewModel: OnboardingViewModel) {
    self.onboardingViewModel = onboardingViewModel
    self.selectedIndex = 0
  }
  
  fileprivate var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(Array(onboardingViewModel.onboardingContent.enumerated()), id: \.element) { index, onboardingContent in
        OnboardingCellView(onboardingContent: onboardingContent)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
    .background (
      selectedIndex % 2 == 0
      ? .customSky
      : .customBackgroundGreen
    )
    .clipped()
  }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
  private var onboardingContent: OnboardingContent
  
  init(onboardingContent: OnboardingContent) {
    self.onboardingContent = onboardingContent
  }
  
  fileprivate var body: some View {
    VStack {
      Image(onboardingContent.imageFileName)
        .resizable()
        .scaledToFit()
      
      Spacer()
    }
    .overlay(
      VStack {
        Spacer()
        
        HStack {
          VStack(spacing: 5) {
            Spacer()
              .frame(height: 46)
            
            Text(onboardingContent.title)
              .font(.system(size: 16, weight: .bold))
            
            Text(onboardingContent.subTitle)
              .font(.system(size: 16))
          }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(.customWhite)
        .cornerRadius(0)
      }
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    )
  }
}

private struct StartButtonView: View {
  @EnvironmentObject var pathModel: PathModel
  
  fileprivate var body: some View {
    Button (
      action: {
        pathModel.paths.append(.todoView)
        print(pathModel.paths)
      },
      label: {
        HStack {
          Text("시작하기")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.customGreen)
          Image("startHome")
            .renderingMode(.template)
            .foregroundColor(.customGreen)
        }
      }
    )
    .padding(.bottom, 60)
  }
}

#Preview {
  OnboardingView()
}
