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
    private let itemHeight:CGFloat = 30
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 5) {
                if player.id == nil {
                    ProfileEmptyView().padding(.horizontal)
                } else {
                    ProfileView(vm: ProfileViewModel(id: "\(player.id!)")).padding(.horizontal)
                }
                HeroImageView(heroID: player.heroID, type: .portrait)
                    .frame(height: 400)
//                    .offset(y: -50)
//                    .padding(.top, 50)
//                    .padding(.bottom, -55)
                HStack {
                    HeroImageView(heroID: player.heroID, type: .icon)
                        .frame(width:30, height: 30)
                    Text("\(heroData.fetchHeroWithID(id: player.heroID)!.localizedName)").font(.custom(fontString, size: 30)).bold()
                }.padding(.horizontal)
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
                Text("Items").font(.custom(fontString, size: 15)).bold().padding(.horizontal).foregroundColor(Color(.systemGray))
                HStack {
                    ItemView(id: player.item0).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item1).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item2).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item3).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item4).aspectRatio(contentMode: .fit)
                    ItemView(id: player.item5).aspectRatio(contentMode: .fit)
                    if player.itemNeutral != nil {
                        ItemView(id: player.itemNeutral!).aspectRatio(contentMode: .fit).clipShape(Circle())
                            .frame(height: itemHeight)
                    }
                }.padding(.horizontal)
                
                if player.abilityUpgrade != nil {
                    Text("Ability Upgrade").font(.custom(fontString, size: 15)).bold().padding(.horizontal).foregroundColor(Color(.systemGray))
//                    ScrollView(.horizontal, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)), count: 6)) {
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
                        }.padding(.horizontal)
//                    }
                }
            }.padding(.vertical)
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
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailView(player: Match.sample.players.first!)
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
    }
}
