//
//  SettingsView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    VStack {
      TitleView()
      
      Spacer()
        .frame(height: 35)
      
      TotalsTabCountView()
      
      Spacer()
        .frame(height: 40)
      
      TotalTabMoveView()
      
      Spacer()
    }
  }
}

private struct TitleView: View {
  fileprivate var body: some View {
    HStack {
      Text("설정")
        .font(.system(size: 30, weight: .bold))
        .foregroundColor(.customBlack)
      
      Spacer()
    }
    .padding(.horizontal, 30)
    .padding(.top, 45)
  }
}

private struct TotalsTabCountView: View {
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  fileprivate var body: some View {
    HStack {
      TabCountView(
        title: "To do",
        count: homeViewModel.todosCount
      )
      
      Spacer()
        .frame(width: 70)
      
      TabCountView(
        title: "메모",
        count: homeViewModel.memosCount
      )
      
      Spacer()
        .frame(width: 70)
      
      TabCountView(
        title: "음성 메모",
        count: homeViewModel.voiceRecordersCount
      )
    }
  }
}

private struct TabCountView: View {
  private var title: String
  private var count: Int
  
  fileprivate init(
    title: String,
    count: Int
  ) {
    self.title = title
    self.count = count
  }
  
  fileprivate var body: some View {
    VStack(spacing: 5) {
      Text(title)
        .font(.system(size: 14))
        .foregroundColor(.customBlack)
      
      Text("\(count)")
        .font(.system(size: 30, weight: .medium))
        .foregroundColor(.customBlack)
    }
  }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  fileprivate var body: some View {
    VStack {
      CustomDividerView()
      
      TabMoveView(
        title: "To do list",
        tabAction: {
          homeViewModel.changeSelectedTab(.todoList)
        }
      )
      
      TabMoveView(
        title: "메모",
        tabAction: {
          homeViewModel.changeSelectedTab(.memo)
        }
      )
      
      TabMoveView(
        title: "음성메모",
        tabAction: {
          homeViewModel.changeSelectedTab(.voiceRecorder)
        }
      )
      
      TabMoveView(
        title: "타이머",
        tabAction: {
          homeViewModel.changeSelectedTab(.timer)
        }
      )
      
      CustomDividerView()
    }
  }
}

private struct TabMoveView: View {
  private var title: String
  private var tabAction: () -> Void
  
  fileprivate init(
    title: String,
    tabAction: @escaping () -> Void
  ) {
    self.title = title
    self.tabAction = tabAction
  }
  
  fileprivate var body: some View {
    Button(
      action: tabAction,
      label: {
        HStack {
          Text(title)
            .font(.system(size: 14))
            .foregroundColor(.customBlack)
          
          Spacer()
          
          Image("arrowRight")
        }
      }
    )
    .padding(20)
  }
}

#Preview {
  SettingsView()
    .environmentObject(HomeViewModel())
}
