//
//  D2AError.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Foundation

struct D2AError: LocalizedError {
  let message: String

  var errorDescription: String? {
    message
  }
}
