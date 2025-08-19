//
//  PathType.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

enum PathType: Hashable {
  case homeView
  case todoView
  case memoView(isCreateMode: Bool, memo: Memo?)
}
