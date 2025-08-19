//
//  MemoListViewModel.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

class MemoListViewModel: ObservableObject {
  @Published var memos: [Memo]
  @Published var removeMemos: [Memo]
  @Published var isEditMemoMode: Bool
  @Published var isDisplayRemoveMemoAlert: Bool
  
  var removeMemosCount: Int {
    return removeMemos.count
  }
  
  var navigationBarRightButtonMode: NavigationButtonType {
    isEditMemoMode ? .complete : .edit
  }
  
  init(
    memos: [Memo] = [],
    removeMemos: [Memo] = [],
    isEditMemoMode: Bool = false,
    isDisplayRemoveMemoAlert: Bool = false
  ) {
    self.memos = memos
    self.removeMemos = removeMemos
    self.isEditMemoMode = isEditMemoMode
    self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
  }
}

extension MemoListViewModel {
  func addMemo(_ memo: Memo) {
    memos.append(memo)
  }
  
  func updateMemo(_ memo: Memo) {
    if let index = memos.firstIndex(where: { $0.id == memo.id }) {
      memos[index] = memo
    }
  }
  
  func removeMemo(_ memo: Memo) {
    if let index = memos.firstIndex(where: { $0.id == memo.id }) {
      memos.remove(at: index)
    }
  }
  
  func navigationRightButtonTapped() {
    if isEditMemoMode {
      if removeMemos.isEmpty {
        isEditMemoMode = false
      } else {
        setIsDisplayRemoveMemoAlert(true)
      }
    } else {
      isEditMemoMode = true
    }
  }
  
  func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {
    isDisplayRemoveMemoAlert = isDisplay
  }
  
  func memoRemoveSelectedBoxTapped(_ memo: Memo) {
    if let index = removeMemos.firstIndex(of: memo) {
      removeMemos.remove(at: index)
    } else {
      removeMemos.append(memo)
    }
  }
  
  func removeButtonTapped() {
    memos.removeAll { memo in
      removeMemos.contains(memo)
    }
    removeMemos.removeAll()
    isEditMemoMode = false
  }
}
