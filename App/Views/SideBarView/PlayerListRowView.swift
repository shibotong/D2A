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
            VStack(spacing: 0) {
                ProfileAvartar(url: vm.profile?.avatarfull ?? "", sideLength: 50, cornerRadius: 25)
                Spacer().frame(height: 10)
                Text(vm.profile?.personaname ?? "nil")
                    .font(.custom(fontString, size: 12))
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(Color(UIColor.label))
                    
                HStack {
                    Image("rank_\((vm.profile?.rank ?? 0) / 10)")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(DataHelper.transferRank(rank: vm.profile?.rank))
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
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                    Spacer()
                }
            }
            .padding(6)
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
