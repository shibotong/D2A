//
//  AVAsset.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import AVFoundation

extension AVAsset {
  func isPlayable() async -> Bool {
    if #available(iOS 16.0, *) {
      do {
        return try await load(.isPlayable)
      } catch {
        logError("An error thrown when checking video is playable: \(error)", category: .video)
        return false
      }
    } else {
      return isPlayable
    }
  }
}
