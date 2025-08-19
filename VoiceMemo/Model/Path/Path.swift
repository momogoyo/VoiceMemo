//
//  Path.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import Foundation

// MARK: - Path 스택을 구성하는 모델
class PathModel: ObservableObject {
  @Published var paths: [PathType]
  
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
