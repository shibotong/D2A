//
//  UserProfileRowView.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import SwiftUI

struct UserProfileRowView: View {
    var profile: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileAvatar(profile: profile, cornerRadius: 10)
            Spacer().frame(height: 10)
            HStack(spacing: 0) {
                if profile.name != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                }
                Text(profile.name ?? profile.personaname ?? "")
                    .font(.system(size: 12))
                    .foregroundColor(.label)
                    .lineLimit(1)
            }
            HStack(spacing: 0) {
                Image("rank_\((profile.rank) / 10)")
                    .resizable()
                    .frame(width: 12, height: 12)
                Text(DataHelper.transferRank(rank: Int(profile.rank)))
                    .font(.system(size: 10))
                    .foregroundColor(.secondaryLabel)
            }
            Text(profile.id ?? "")
                .font(.system(size: 9))
                .foregroundColor(.tertiaryLabel)
        }
        .font(.subheadline)
    }
}
