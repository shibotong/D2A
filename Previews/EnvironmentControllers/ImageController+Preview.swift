//
//  ImageController+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

extension ImageController {
    static let preview = ImageController(imageProvider: PreviewImageProvider(),
                                         userDefaults: .standard)
}
