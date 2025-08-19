//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

class MemoViewModel: ObservableObject {
  @Published var memo: Memo
  
  init(
    memo: Memo
  ) {
    self.memo = memo
  }
}
