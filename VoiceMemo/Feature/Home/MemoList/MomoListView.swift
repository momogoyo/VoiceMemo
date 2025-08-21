//
//  MomoListView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct MemoListView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    ZStack {
      VStack {
        if !memoListViewModel.memos.isEmpty {
          CustomNavigationBar(
            isDisplayLeftButton: false,
            rightButtonAction: {
              memoListViewModel.navigationRightButtonTapped()
            },
            rightButtonType: memoListViewModel.navigationBarRightButtonMode
          )
        } else {
          Spacer()
            .frame(height: 30)
        }
        
        TitleView()
          .padding(.top, 20)
        
        if memoListViewModel.memos.isEmpty {
          AnnouncementView()
        } else {
          MemoListContentView()
            .padding(.top, 20)
        }
        
        WriteMemoButtonView()
          .padding(.trailing, 20)
          .padding(.bottom, 50)
      }
    }
    .alert(
      "메모 \(memoListViewModel.removeMemos.count)개 삭제하시겠습니까?",
      isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
    ) {
      Button("삭제", role: .destructive) {
        memoListViewModel.removeButtonTapped()
      }
      Button("취소", role: .cancel) { }
    }
    .onChange(of: memoListViewModel.memos) { _, memos in
      homeViewModel.setMemosCount(memos.count)
    }
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  
  fileprivate var body: some View {
    HStack {
      if memoListViewModel.memos.isEmpty {
        Text("메모를\n추가해보세요")
      } else {
        Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
      }
      
      Spacer()
    }
    .font(.system(size: 30, weight: .bold))
    .padding(.leading, 30)
  }
}

// MARK: - MemoList 안내 뷰
private struct AnnouncementView: View {
  fileprivate var body: some View {
    VStack(spacing: 15) {
      Spacer()
      
      Image("pencil")
        .renderingMode(.template)
      
      VStack(spacing: 8) {
        Text(" \"퇴근 9시간 전 메모\" ")
        Text(" \"기획서 작성 후 퇴근하기 메모\" ")
        Text(" \"밀린 집안일 하기 메모\" ")
      }
    }
    .font(.system(size: 16))
    .foregroundColor(.customGray2)
  }
}

// MARK: - MemoList 컨텐츠 뷰
private struct MemoListContentView: View {
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  
  fileprivate var body: some View {
    VStack(alignment: .leading) {
      Text("메모 목록")
        .font(.system(size: 15, weight: .bold))
        .padding(.leading, 20)
      
      CustomDividerView(.customGray0)
      
      ScrollView(.vertical) {
        VStack {
          ForEach(memoListViewModel.memos, id: \.self) { memo in
            MemoListCellView(memo: memo)
          }
        }
      }
    }
  }
}

private struct MemoListCellView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var memoListViewModel: MemoListViewModel
  @State private var isRemoveSelected: Bool
  private var memo: Memo
  
  init(
    isRemoveSelected: Bool = false,
    memo: Memo
  ) {
    self.memo = memo
    _isRemoveSelected = State(initialValue: isRemoveSelected)
  }
  
  var body: some View {
    Button(
      action: {
        // TODO: - Memo Viewer 모드로 보여주기
        pathModel.paths.append(
          .memoView(
            isCreateMode: false,
            memo: memo
          )
        )
      },
      label: {
        VStack(spacing: 20) {
          HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
              Text(memo.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.customBlack)
              
              Text(memo.convertedDayAndTime)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.customIconGray)
            }
            
            Spacer()
            
            if memoListViewModel.isEditMemoMode {
              Button(
                action: {
                  isRemoveSelected.toggle()
                  memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                },
                label: {
                  isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                }
              )
            }
          }
        }
      }
    )
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    
    CustomDividerView(.customGray0)
  }
}

// MARK: - 메모 생성 버튼 뷰
private struct WriteMemoButtonView: View {
  @EnvironmentObject private var pathModel: PathModel
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Spacer()
        
        Button(
          action: {
            pathModel.paths.append(
              .memoView(
                isCreateMode: true,
                memo: nil
              )
            )
          },
          label: {
            Image("writeBtn")
          }
        )
      }
    }
  }
}

#Preview {
  MemoListView()
    .environmentObject(MemoListViewModel())
    .environmentObject(PathModel())
}
