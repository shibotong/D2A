//
//  PlayerRowView.swift
//  App
//
//  Created by Shibo Tong on 6/6/2022.
//

import SwiftUI

struct PlayerListRowView: View {
    @ObservedObject var vm: SidebarRowViewModel
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        ZStack {
            if let profile = vm.profile {
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
                        Text(DataHelper.transferRank(rank: Int(vm.profile?.rank ?? 0)))
                            .font(.custom(fontString, size: 10))
                            .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                    }
                    Text("\(vm.userid)")
                        .font(.custom(fontString, size: 9))
                        .foregroundColor(Color(uiColor: UIColor.tertiaryLabel))
                }
                .padding()
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            env.delete(userID: vm.userid)
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
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onAppear {
            vm.loadProfile()
        }
    }
}

struct PlayerListRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListRowView(vm: SidebarRowViewModel(userid: "177416702"))
            .previewLayout(.fixed(width: 100, height: 150))
            .environmentObject(DotaEnvironment.preview)
    }
}
