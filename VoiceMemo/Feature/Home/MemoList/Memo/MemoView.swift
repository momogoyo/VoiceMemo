//
//  MemoView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct MemoView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  /// 뷰를 생성할 때 init을 해주는 구조 또는 여기서 인스턴스를 생성하던지 하는건가?
  @StateObject var memoViewModel: MemoViewModel
  @State var isCreateMode: Bool = true
  
  var body: some View {
    VStack {
      CustomNavigationBar(
        leftButtonAction: {
          pathModel.paths.removeLast()
        },
        rightButtonAction: {
          if isCreateMode {
            memoListViewModel.addMemo(memoViewModel.memo)
          } else {
            memoListViewModel.updateMemo(memoViewModel.memo)
          }
          
          pathModel.paths.removeLast()
        },
        rightButtonType: isCreateMode ? .create : .complete
      )
      
      MemoTitleInputView(memoViewModel: memoViewModel, isCreateMode: $isCreateMode)
        .padding(.top, 20)
      
      MemoContentInputView(memoViewModel: memoViewModel)
        .padding(.top, 10)
      
      if !isCreateMode {
        RemoveMemoButtonView(memoViewModel: memoViewModel)
          .padding(.trailing, 20)
          .padding(.bottom, 10)
      }
      
    }
  }
}

// MARK: - 메모 제목 입력 뷰
private struct MemoTitleInputView: View {
  /// @ObservedObject: 관찰만 가능, 반드시 외부에서 주입받아야함
  @ObservedObject private var memoViewModel: MemoViewModel
  @FocusState private var isTitleFieldFocused: Bool
  @Binding private var isCreateMode: Bool
  
  fileprivate init(
    memoViewModel: MemoViewModel,
    isCreateMode: Binding<Bool>
  ) {
    self.memoViewModel = memoViewModel
    self._isCreateMode = isCreateMode
  }
  
  fileprivate var body: some View {
    TextField(
      "제목을 입력하세요",
      text: $memoViewModel.memo.title
    )
    .font(.system(size: 30))
    .padding(.horizontal, 20)
    .focused($isTitleFieldFocused)
    .onAppear {
      if isCreateMode {
        isTitleFieldFocused = true
      }
    }
  }
}

// MARK: - 메모 본문 입력 뷰
private struct MemoContentInputView: View {
  @ObservedObject private var memoViewModel: MemoViewModel
  
  fileprivate init(memoViewModel: MemoViewModel) {
    self.memoViewModel = memoViewModel
  }
  
  fileprivate var body: some View {
    ZStack(alignment: .leading) {
      TextEditor(
        text: $memoViewModel.memo.content
      )
      .font(.system(size: 20))
      
      if memoViewModel.memo.content.isEmpty {
        VStack {
          Text("메모를 입력하세요...")
            .font(.system(size: 16))
            .foregroundColor(.customGray1)
            .padding(.top, 10)
            .padding(.leading, 5)
          
          Spacer()
        }
      }
    }
    .padding(.horizontal, 20)
  }
}

// MARK: - 삭제 플로팅 뷰
private struct RemoveMemoButtonView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  @ObservedObject private var memoViewModel: MemoViewModel
  
  fileprivate init(memoViewModel: MemoViewModel) {
    self.memoViewModel = memoViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      Spacer()

      HStack {
        Spacer()
        
        Button(
          action: {
            memoListViewModel.removeMemo(memoViewModel.memo)
            pathModel.paths.removeLast()
          },
          label: {
            Image("trash")
              .resizable()
              .frame(width: 40, height: 40)
              .foregroundColor(.customIconGray)
          }
        )
      }
    }
  }
}

#Preview {
  MemoView(
    memoViewModel: .init(
      memo: .init(
        title: "",
        content: "",
        date: Date()
      )
    ),
    isCreateMode: false
  )
}
