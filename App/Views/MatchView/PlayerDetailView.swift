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
                        HeroImageView(heroID: player.heroID, type: .portrait).frame(height: 300)
                        buildHeroName()
                        buildStats()
                        buildItem()
                        if player.abilityUpgrade != nil {
                            buildAbiltyUpgrade(items: 6)
                        }
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
                                HeroImageView(heroID: player.heroID, type: .portrait).frame(width: proxy.size.width / 3)
                                VStack {
                                    buildHeroName()
                                    buildStats()
                                    buildItem()
                                }
                            }
                        }.frame(height: 250)
                        if player.abilityUpgrade != nil {
                            buildAbiltyUpgrade(items: 10)
                        }
                    }.padding()
                }
            }
        }
    }
    
    @ViewBuilder private func buildAbiltyUpgrade(items: Int) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Ability Upgrade").font(.custom(fontString, size: 15)).bold().foregroundColor(Color(.systemGray))
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50, maximum: 50)), count: 6)) {
                ForEach(0..<player.abilityUpgrade!.count, id: \.self) { index in
                    buildAbility(abilityID: player.abilityUpgrade![index])
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
                Text("Items").font(.custom(fontString, size: 15)).bold().foregroundColor(Color(.systemGray))
                HStack {
                    ItemView(id: player.item0).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item1).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item2).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item3).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item4).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item5).aspectRatio(contentMode: .fit)
                    if player.itemNeutral != nil {
                        ItemView(id: player.itemNeutral!).aspectRatio(contentMode: .fit).clipShape(Circle())
                    }
                }
            }.padding(.horizontal)
        
    }
    
    @ViewBuilder private func buildHeroName() -> some View {
        HStack {
            HeroImageView(heroID: player.heroID, type: .icon)
                .frame(width:30, height: 30)
            Text(LocalizedStringKey(heroData.fetchHeroWithID(id: player.heroID)?.localizedName ?? "Unknown Hero (\(player.heroID))")).font(.custom(fontString, size: 30)).bold()
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
                KDAView(kills: player.kills, deaths: player.deaths, assists: player.assists, size: .caption)
            }.padding(.horizontal).font(.custom(fontString, size: 15))
            HStack {
                HStack {
                    Circle().frame(width: 10, height: 10).foregroundColor(.red)
                    Text("\(player.heroDamage ?? 0)").bold()
                    Text("Damage").foregroundColor(Color(.systemGray))
                }
                Spacer()
                //buildMultiKill
            }.padding(.horizontal).font(.custom(fontString, size: 15))
            Text("LH: \(getPlayerHits(last: true))  DN: \(getPlayerHits(last: false))").font(.custom(fontString, size: 15)).padding(.horizontal)
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
            if let ability = HeroDatabase.shared.fetchAbility(name: abilityName), let img = ability.img, ability.desc != "Associated ability not drafted, have some gold!" {
                    let parsedimgURL = img.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                ProfileAvartar(url: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 50, cornerRadius: 0)
//                    WebImage(url: URL(string: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)"))
//                        .resizable()
//                        .renderingMode(.original)
//                        .indicator(.activity)
//                        .transition(.fade)
//                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("ability_slot")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(.systemBackground))
                        .overlay(
                            ZStack {
                                Rectangle().stroke()
                                if abilityID == 730 {
                                    Text("Bonus Attributes").font(.custom(fontString, size: 8)).padding(0.5)
                                } else {
                                    Text(NSLocalizedString(abilityName, comment: "")).font(.custom(fontString, size: 8)).padding(0.5)
                                }
                            }
                        )
                }
        } else {
            // Cannot find ability with ID
            Image("ability_slot")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(.systemBackground))
                .overlay(
                    ZStack {
                        Rectangle().stroke()
                        Text("Unknown: \(abilityID)").font(.custom(fontString, size: 8)).padding(0.5)
                    }
                )
        }
    }
    @ViewBuilder private func profileHost(playerID: Int?) -> some View {
        if player.accountId == nil {
            ProfileEmptyView()
        } else {
            ProfileView(vm: ProfileViewModel(id: "\(playerID!)"))
        }
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerDetailView(player: Match.sample.players.first!)
                .environmentObject(DotaEnvironment.shared)
                .environmentObject(HeroDatabase.shared)
            PlayerDetailView(player: Match.sample.players.first!)
                .previewLayout(.fixed(width: 704, height: 1000))
                .environmentObject(DotaEnvironment.shared)
                .environmentObject(HeroDatabase.shared)
        }
    }
}
