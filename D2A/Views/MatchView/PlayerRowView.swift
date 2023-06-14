//
//  PlayerRowView.swift
//  D2A
//
//  Created by Shibo Tong on 16/12/2022.
//

import SwiftUI
import StratzAPI

struct PlayerRowView: View {
    var maxDamage: Int
    @ObservedObject var viewModel: PlayerRowViewModel
    @EnvironmentObject var heroData: HeroDatabase
    
    private var heroIcon: some View {
        HeroImageView(heroID: viewModel.heroID, type: .icon)
            .frame(width: 35, height: 35)
            .overlay(HStack {
                Spacer()
                VStack {
                    Spacer()
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.label)
                        .overlay(Text("\(viewModel.level)")
                                    .foregroundColor(Color(.systemBackground))
                                    .font(.system(size: 8)).bold())
                }
            })
    }
    
    private var leadingView: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let personaname = viewModel.personaname {
                HStack(spacing: 2) {
                    Image("rank_\(viewModel.rank / 10)").resizable().frame(width: 18, height: 18)
                    Text(personaname.description).font(.system(size: 15)).bold().lineLimit(1).foregroundColor(.label)
                }
            } else {
                Text("Anonymous").font(.system(size: 15)).bold().lineLimit(1)
            }
            KDAView(kills: viewModel.kills, deaths: viewModel.deaths, assists: viewModel.assists, size: .caption)
        }.frame(width: 120)
    }
    
    private var itemsView: some View {
        HStack(spacing: 5) {
            let width: CGFloat = 40.0
            let height = width * 0.75
            if let item = viewModel.itemNeutral {
                ItemView(id: item)
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .frame(width: height)
            }
            Group {
                ItemView(id: viewModel.item0).frame(width: width, height: height)
                ItemView(id: viewModel.item1).frame(width: width, height: height)
                ItemView(id: viewModel.item2).frame(width: width, height: height)
                ItemView(id: viewModel.item3).frame(width: width, height: height)
                ItemView(id: viewModel.item4).frame(width: width, height: height)
                ItemView(id: viewModel.item5).frame(width: width, height: height)
            }
            Spacer().frame(width: 20)
            Group {
                if let backpack0 = viewModel.backpack0 {
                    ItemView(id: backpack0).frame(width: width, height: height)
                }
                if let backpack1 = viewModel.backpack1 {
                    ItemView(id: backpack1).frame(width: width, height: height)
                }
                if let backpack2 = viewModel.backpack2 {
                    ItemView(id: backpack2).frame(width: width, height: height)
                }
            }
        }
    }
    
    private var scepterView: some View {
        VStack(spacing: 0) {
            Image("scepter_\(viewModel.hasScepter ? "1" : "0")")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                
            Image("shard_\(viewModel.hasShard ? "1" : "0")")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 12)
        }.frame(width: 10)
    }
    
    private var abilityView: some View {
        HStack(spacing: 1) {
            ForEach(0..<viewModel.abilityUpgrade.count, id: \.self) { index in
                buildAbility(abilityID: viewModel.abilityUpgrade[index])
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
                NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: viewModel.heroID))) {
                    heroIcon
                }
                if let playerID = viewModel.accountID {
                    NavigationLink(destination: PlayerProfileView(userid: playerID)) {
                        leadingView
                    }
                } else {
                    leadingView
                }
                VStack(spacing: 0) {
                    if viewModel.gpm != 0 {
                        HStack(spacing: 3) {
                            Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemYellow))
                            Text("\(viewModel.gpm)").foregroundColor(Color(.systemOrange))
                        }.frame(width: 40)
                    }
                    if viewModel.xpm != 0 {
                        HStack(spacing: 3) {
                            Circle().frame(width: 8, height: 8).foregroundColor(Color(.systemBlue))
                            Text("\(viewModel.xpm)").foregroundColor(Color(.systemBlue))
                        }.frame(width: 40)
                    }
                    if maxDamage != 0 {
                        DamageView(maxDamage: maxDamage, playerDamage: Int(viewModel.heroDamage ?? 0))
                    }
                }.font(.system(size: 10))
                itemsView
                scepterView
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
                    AbilityImage(viewModel: AbilityImageViewModel(name: abilityName, urlString: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 40, cornerRadius: 0))
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

// struct PlayerRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerRowView(player: Player(id: "1", slot: 0), isRadiant: true, maxDamage: 1000)
//    }
// }
