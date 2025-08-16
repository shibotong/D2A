//
//  UserProfile+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

extension UserProfile {
    static var user: UserProfile {
        let user = OpenDotaProvider.user
        let context = PersistanceProvider.previewProvider.mainContext
        return try! user.update(context: context) as! UserProfile
    }
}
