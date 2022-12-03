//
//  PlayerRowView.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import SwiftUI

struct PlayerListRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var profile: UserProfile
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ProfileAvartar(profile: profile, sideLength: 50, cornerRadius: 25)
                Spacer().frame(height: 10)
                HStack(spacing: 0) {
                    if profile.name != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                    }
                    Text(profile.name ?? profile.personaname ?? "")
                        .font(.custom(fontString, size: 12))
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(Color(UIColor.label))
                }
                
                HStack(spacing: 0) {
                    Image("rank_\((profile.rank) / 10)")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(DataHelper.transferRank(rank: Int(profile.rank)))
                        .font(.custom(fontString, size: 10))
                        .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                }
                Text(profile.id ?? "")
                    .font(.custom(fontString, size: 9))
                    .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
            }
            .padding()
            HStack {
                Spacer()
                VStack {
                    Button {
                        profile.favourite = false
                        try? viewContext.save()
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.primaryDota)
                            .font(.caption)
                    }
                    Spacer()
                }
            }
            .padding(6)
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
