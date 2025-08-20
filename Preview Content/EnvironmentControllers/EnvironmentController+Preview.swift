//
//  ImageController+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

import Foundation

extension EnvironmentController {
    static let preview = EnvironmentController(imageProvider: MockImageProvider(), imageCache: ImageCache(), userDefaults: UserDefaults.standard)
}
