//
//  ImageController+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

import Foundation

extension ImageController {
    static let preview = ImageController(imageProvider: MockImageProvider(),
                                         userDefaults: UserDefaults.standard)
}
