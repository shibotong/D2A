//
//  PlayerDetailView.swift
//  App
//
//  Created by Shibo Tong on 3/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

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
                        buildAbiltyUpgrade(items: 10)
                    }.padding()
                }
            }
        }
    }
    
    @ViewBuilder private func buildAbiltyUpgrade(items: Int) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Ability Upgrade").font(.custom(fontString, size: 15)).bold().foregroundColor(Color(.systemGray))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)), count: items)) {
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
            Text("\(heroData.fetchHeroWithID(id: player.heroID)!.localizedName)").font(.custom(fontString, size: 30)).bold()
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
                KDAView(kills: player.kills, deaths: player.deaths, assists: player.assists, size: 15)
            }.padding(.horizontal).font(.custom(fontString, size: 15))
            HStack {
                HStack {
                    Circle().frame(width: 10, height: 10).foregroundColor(.red)
                    Text("\(player.heroDamage!)").bold()
                    Text("Damage").foregroundColor(Color(.systemGray))
                }
                Spacer()
                //buildMultiKill
            }.padding(.horizontal).font(.custom(fontString, size: 15))
            Text("LH: \(player.lastHits)  DN: \(player.denies)").font(.custom(fontString, size: 15)).padding(.horizontal)
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
        if let ability = HeroDatabase.shared.fetchAbility(id: abilityID) {
            if let img = ability.img {
                WebImage(url: URL(string: "https://api.opendota.com\(img)"))
                    .resizable()
                    .renderingMode(.original)
                    .indicator(.activity)
                    .transition(.fade)
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: side, height: side)
            } else {
                GeometryReader { geo in
                    ZStack {
                        Rectangle().stroke()
                        Text(ability.dname ?? "Unknown").font(.custom(fontString, size: 8)).padding(0.5)
                    }.frame(height: geo.size.width)
                }
            }
        }else {
            Text("cannot find")
        }
    }
    @ViewBuilder private func profileHost(playerID: Int?) -> some View {
        if player.accountId == nil {
            ProfileEmptyView()
        } else {
            ProfileView(vm: ProfileViewModel(id: "\(playerID!)"), presentState: present)
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
