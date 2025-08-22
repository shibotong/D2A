//
//  Match+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 20/8/2025.
//

extension Match {
    static var match: Match {
        let match = OpenDotaProvider.match
        let context = PersistanceProvider.previewProvider.mainContext
        return match.update(context: context)
    }
}
