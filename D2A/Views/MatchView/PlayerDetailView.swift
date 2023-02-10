//
//  PlayerDetailView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI

struct PlayerDetailView: View {
    var player: Player
    @EnvironmentObject var heroData: HeroDatabase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.presentationMode) var present
    private let itemHeight:CGFloat = 30
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack(spacing: 0) {
                profileHost(playerID: player.accountId).padding()
                Divider()
                ScrollView {
                    VStack (alignment: .center, spacing: 5) {
                        HeroImageView(heroID: Int(player.heroID), type: .portrait).frame(height: 300)
                        buildHeroName()
                        buildStats()
                        buildItem()
                        buildAbiltyUpgrade(items: 6)
                    }.padding()
                }
            }
        } else {
            VStack(spacing: 0) {
                profileHost(playerID: player.accountId)
                    .padding()
                Divider()
                ScrollView {
                    VStack {
                        GeometryReader { proxy in
                            HStack {
                                HeroImageView(heroID: Int(player.heroID), type: .portrait).frame(width: proxy.size.width / 3)
                                VStack {
                                    buildHeroName()
                                    buildStats()
                                    buildItem()
                                }
                            }
                        }.frame(height: 250)
                        buildAbiltyUpgrade(items: 10)
                    }.padding()
                }
            }
        }
    }
    
    @ViewBuilder private func buildAbiltyUpgrade(items: Int) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Ability Upgrade").font(.system(size: 15)).bold().foregroundColor(Color(.systemGray))
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50)), count: 6)) {
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
        }.padding(.horizontal)
    }
    
    @ViewBuilder private func buildItem() -> some View {
            VStack(alignment: .leading, spacing: 1) {
                Text("Items").font(.system(size: 15)).bold().foregroundColor(Color(.systemGray))
                HStack {
                    ItemView(id: Int(player.item0)).aspectRatio(contentMode: .fit)
                    ItemView(id: Int(player.item1)).aspectRatio(contentMode: .fit)
                    ItemView(id: Int(player.item2)).aspectRatio(contentMode: .fit)
                    ItemView(id: Int(player.item3)).aspectRatio(contentMode: .fit)
                    ItemView(id: Int(player.item4)).aspectRatio(contentMode: .fit)
                    ItemView(id: Int(player.item5)).aspectRatio(contentMode: .fit)
                    if let itemNeutral = player.itemNeutral {
                        ItemView(id: Int(itemNeutral)).aspectRatio(contentMode: .fit).clipShape(Circle())
                    }
                }
            }.padding(.horizontal)
        
    }
    
    @ViewBuilder private func buildHeroName() -> some View {
        let hero = try? heroData.fetchHeroWithID(id: Int(player.heroID))
        HStack {
            HeroImageView(heroID: Int(player.heroID), type: .icon)
                .frame(width:30, height: 30)
            Text(LocalizedStringKey(hero?.localizedName ?? "Unknown Hero \(player.heroID)")).font(.system(size: 30)).bold()
            Spacer()
        }.padding(.horizontal)
    }
    
    @ViewBuilder private func buildStats() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Circle().frame(width: 10, height: 10).foregroundColor(.yellow)
                    Text("\(player.gpm)").bold()
                    Text("GPM").foregroundColor(Color(.systemGray))
                }
                HStack {
                    Circle().frame(width: 10, height: 10).foregroundColor(.blue)
                    Text("\(player.xpm)").bold()
                    Text("XPM").foregroundColor(Color(.systemGray))
                }
                Spacer()
                KDAView(kills: Int(player.kills), deaths: Int(player.deaths), assists: Int(player.assists), size: .caption)
            }.padding(.horizontal).font(.system(size: 15))
            HStack {
                HStack {
                    Circle().frame(width: 10, height: 10).foregroundColor(.red)
                    Text("\(player.heroDamage ?? 0)").bold()
                    Text("Damage").foregroundColor(Color(.systemGray))
                }
                Spacer()
                //buildMultiKill
            }.padding(.horizontal).font(.system(size: 15))
            Text("LH: \(getPlayerHits(last: true))  DN: \(getPlayerHits(last: false))").font(.system(size: 15)).padding(.horizontal)
        }
    }
    
    private func getPlayerHits(last: Bool) -> String {
        if last {
            return "\(player.lastHits)"
        } else {
            return "\(player.denies)"
        }
    }
    
    @ViewBuilder private func buildMultiKill(multiKill: [String: Int]) -> some View {
        // TODO: Multikills
        if multiKill.count == 0 {
            EmptyView()
        } else {
            let kills = multiKill.keys
            Text("Tripple Kill \(kills.description)").padding(.horizontal, 6)
                .background(Capsule().stroke())
                .foregroundColor(.red)
        }
    }
    @ViewBuilder private func buildAbility(abilityID: Int) -> some View {
        if let abilityName = HeroDatabase.shared.fetchAbilityName(id: abilityID) {
            if let ability = HeroDatabase.shared.fetchOpenDotaAbility(name: abilityName) {
                if let img = ability.img, ability.desc != "Associated ability not drafted, have some gold!", let name = ability.name {
                    let parsedimgURL = img.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                    AbilityImage(name: name, urlString: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 50, cornerRadius: 0)
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
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(.systemBackground))
            .overlay(
                ZStack {
                    Rectangle().stroke()
                    Text(LocalizedStringKey(text)).font(.system(size: 8)).padding(0.5)
                }
            )
    }

    @ViewBuilder private func profileHost(playerID: String?) -> some View {
        if let playerID = playerID {
            ProfileView(vm: ProfileViewModel(id: playerID))
        } else {
            ProfileEmptyView()
        }
    }
}
