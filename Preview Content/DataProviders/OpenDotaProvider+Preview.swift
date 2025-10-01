//
//  OpenDotaProvider+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

extension OpenDotaProvider {
    static var user: ODPlayerProfile {
        let previewProvider = PreviewDataProvider.shared
        return previewProvider.loadOpenDotaUser()
    }
}
