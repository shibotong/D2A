//
//  PlayerRowView.swift
//  D2A
//
//  Created by Shibo Tong on 16/12/2022.
//

import SwiftUI

struct PlayerRowView: View {
    var player: Player
    var isRadiant: Bool
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var maxDamage: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HeroImageView(heroID: Int(player.heroID), type: .icon)
                    .frame(width: 35, height: 35)
                    .overlay(HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Circle()
                                .frame(width: 15, height: 15)
                                .overlay(Text("\(player.level)")
                                            .foregroundColor(Color(.systemBackground))
                                            .font(.system(size: 8)).bold())
                        }
                    })
                VStack(alignment: .leading, spacing: 2) {
                    if let personaname = player.personaname {
                        HStack(spacing: 2) {
                            Image("rank_\(player.rank / 10)").resizable().frame(width: 18, height: 18)
                            Text(personaname.description).font(.system(size: 15)).bold().lineLimit(1)
                        }
                    } else {
                        Text("Anonymous").font(.system(size: 15)).bold().lineLimit(1)
                    }
                    KDAView(kills: Int(player.kills), deaths: Int(player.deaths), assists: Int(player.assists), size: .caption)
                }.frame(minWidth: 0)
                Spacer()
//                if let item = player.itemNeutral {
//                    ItemView(id: Int(item))
//                        .frame(width: 24, height: 18)
//                        .clipShape(Circle())
//                        .frame(width: 8)
//                }
//                VStack(spacing: 1) {
//                    HStack(spacing: 1) {
//                        ItemView(id: Int(player.item0)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item1)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item2)).frame(width: 24, height: 18)
//                    }
//                    HStack(spacing: 1) {
//                        ItemView(id: Int(player.item3)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item4)).frame(width: 24, height: 18)
//                        ItemView(id: Int(player.item5)).frame(width: 24, height: 18)
//                    }
//                }
                VStack(spacing: 0) {
                    Image("scepter_\(player.hasScepter ? "1" : "0")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        
                    Image("shard_\(player.hasShard ? "1" : "0")")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 12)
                }.frame(width: 10)
                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                        Text("\(player.gpm)").foregroundColor(Color(.systemOrange))
                    }.frame(width: 40)
                    HStack(spacing: 3) {
                        Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemBlue))
                        Text("\(player.xpm)").foregroundColor(Color(.systemBlue))
                    }.frame(width: 40)
                    DamageView(maxDamage: maxDamage, playerDamage: Int(player.heroDamage ?? 0))
                }.font(.system(size: 10))
            }.frame(height: 50)
        }
    }
}

//struct PlayerRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerRowView(player: Player(id: "1", slot: 0), isRadiant: true, maxDamage: 1000)
//    }
//}
