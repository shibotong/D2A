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
    var maxDamage: Int
    
    @EnvironmentObject var heroData: HeroDatabase
    
    private var heroIcon: some View {
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
    }
    
    private var leadingView: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let personaname = player.personaname {
                HStack(spacing: 2) {
                    Image("rank_\(player.rank / 10)").resizable().frame(width: 18, height: 18)
                    Text(personaname.description).font(.system(size: 15)).bold().lineLimit(1).foregroundColor(.label)
                }
            } else {
                Text("Anonymous").font(.system(size: 15)).bold().lineLimit(1)
            }
            KDAView(kills: Int(player.kills), deaths: Int(player.deaths), assists: Int(player.assists), size: .caption)
        }.frame(width: 100)
    }
    
    private var itemsView: some View {
        HStack(spacing: 5) {
            let width: CGFloat = 40.0
            let height = width * 0.75
            if let item = player.itemNeutral {
                ItemView(id: Int(item))
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .frame(width: height)
            }
            Group {
                ItemView(id: Int(player.item0)).frame(width: width, height: height)
                ItemView(id: Int(player.item1)).frame(width: width, height: height)
                ItemView(id: Int(player.item2)).frame(width: width, height: height)
                ItemView(id: Int(player.item3)).frame(width: width, height: height)
                ItemView(id: Int(player.item4)).frame(width: width, height: height)
                ItemView(id: Int(player.item5)).frame(width: width, height: height)
            }
            Spacer().frame(width: 20)
            Group {
                if let backpack0 = player.backpack0 {
                    ItemView(id: Int(backpack0)).frame(width: width, height: height)
                }
                if let backpack1 = player.backpack1 {
                    ItemView(id: Int(backpack1)).frame(width: width, height: height)
                }
                if let backpack2 = player.backpack2 {
                    ItemView(id: Int(backpack2)).frame(width: width, height: height)
                }
            }
        }
    }
    
    private var scepterView: some View {
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
    }
    
    private var abilityView: some View {
        HStack(spacing: 1) {
            ForEach(0..<player.abilityUpgrade.count, id: \.self) { index in
                buildAbility(abilityID: player.abilityUpgrade[index])
                    .overlay(HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("\(index + 1)").font(.system(size: 10)).foregroundColor(Color(.systemBackground)).background(Color(.label))
                        }
                    })
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                heroIcon
                if let playerID = player.accountId {
                    NavigationLink(destination: PlayerProfileView(userid: playerID)) {
                        leadingView
                    }
                } else {
                    leadingView
                }
                itemsView
                scepterView
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
                abilityView
                Spacer()
            }.frame(height: 50)
        }
    }
    
    @ViewBuilder private func buildAbility(abilityID: Int) -> some View {
        if let abilityName = HeroDatabase.shared.fetchAbilityName(id: abilityID) {
            if let ability = HeroDatabase.shared.fetchOpenDotaAbility(name: abilityName) {
                if let img = ability.img, ability.desc != "Associated ability not drafted, have some gold!" {
                    let parsedimgURL = img.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                AbilityImage(name: abilityName, urlString: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 40, cornerRadius: 0)
                } else {
                    // no image
                    if abilityID == 730 {
                        buildAbilityWithString("Bonus Attributes")
                    } else {
                        buildAbilityWithString(heroData.getTalentDisplayName(id: Short(abilityID)))
                    }
                }
            } else {
                // Cannot find abiilty with name
                buildAbilityWithString(abilityName)
            }
        } else {
            // Cannot find ability with ID
            buildAbilityWithString("Unknown: \(abilityID)")
        }
    }
    
    @ViewBuilder private func buildAbilityWithString(_ text: String) -> some View {
        Image("ability_slot")
            .resizable()
            .renderingMode(.template)
            .frame(width: 40, height: 40)
            .foregroundColor(Color(.systemBackground))
            .overlay(
                ZStack {
                    Rectangle().stroke()
                    Text(LocalizedStringKey(text)).font(.system(size: 8)).padding(0.5)
                }
            )
    }
}

//struct PlayerRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerRowView(player: Player(id: "1", slot: 0), isRadiant: true, maxDamage: 1000)
//    }
//}
