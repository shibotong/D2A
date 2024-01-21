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
    
    var shortVersion: Bool = false
    var showAbility: Bool = true
    
    var body: some View {
        if shortVersion {
            shortPlayerView
        } else {
            longPlayerView
        }
    }
    
    private var longPlayerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: viewModel.heroID))) {
                    heroIcon
                }
                if let playerID = viewModel.accountID {
                    NavigationLink(destination: PlayerProfileView(userid: playerID)) {
                        leadingViewContainer
                    }
                } else {
                    leadingViewContainer
                }
                if !showAbility {
                    Spacer()
                }
                gpmxpmView
                itemsView
                scepterView
                if !showAbility {
                    Spacer().frame(width: 10)
                }
                if showAbility {
                    abilityView
                    Spacer()
                }
            }.frame(height: 50)
        }
    }
    
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
    
    private var leadingViewContainer: some View {
        ZStack {
            if showAbility {
                leadingView.frame(width: 120)
            } else {
                leadingView
            }
        }
    }
    
    private var leadingView: some View {
        HStack {
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
            }
            Spacer()
        }
    }
    
    private var itemsStackView: some View {
        HStack(spacing: 1) {
            let width: CGFloat = 30.0
            let height = width * 0.75

            VStack(spacing: 1) {
                ItemView(id: $viewModel.item0).frame(width: width, height: height)
                ItemView(id: $viewModel.item3).frame(width: width, height: height)
            }
            VStack(spacing: 1) {
                ItemView(id: $viewModel.item1).frame(width: width, height: height)
                ItemView(id: $viewModel.item4).frame(width: width, height: height)
            }
            VStack(spacing: 1) {
                ItemView(id: $viewModel.item2).frame(width: width, height: height)
                ItemView(id: $viewModel.item5).frame(width: width, height: height)
            }
            itemStackBackPackView
        }
    }
    
    private var itemStackBackPackView: some View {
        VStack(spacing: 1) {
            let backPackWidth: CGFloat = 30.0 * 2 / 3
            let backPachHeight = backPackWidth * 0.75
            if viewModel.backpack0 != nil {
                ItemView(id: $viewModel.backpack0).frame(width: backPackWidth, height: backPachHeight)
            }
            if viewModel.backpack1 != nil {
                ItemView(id: $viewModel.backpack1).frame(width: backPackWidth, height: backPachHeight)
            }
            if viewModel.backpack2 != nil {
                ItemView(id: $viewModel.backpack2).frame(width: backPackWidth, height: backPachHeight)
            }
        }
    }
    
    private var itemsView: some View {
        HStack(spacing: 5) {
            let width: CGFloat = 40.0
            let height = width * 0.75
            if viewModel.itemNeutral != nil {
                ItemView(id: $viewModel.itemNeutral)
                    .frame(width: width, height: height)
                    .clipShape(Circle())
                    .frame(width: height)
            }
            Group {
                ItemView(id: $viewModel.item0).frame(width: width, height: height)
                ItemView(id: $viewModel.item1).frame(width: width, height: height)
                ItemView(id: $viewModel.item2).frame(width: width, height: height)
                ItemView(id: $viewModel.item3).frame(width: width, height: height)
                ItemView(id: $viewModel.item4).frame(width: width, height: height)
                ItemView(id: $viewModel.item5).frame(width: width, height: height)
            }
            Spacer().frame(width: 20)
            Group {
                if viewModel.backpack0 != nil {
                    ItemView(id: $viewModel.backpack0).frame(width: width, height: height)
                }
                if viewModel.backpack1 != nil {
                    ItemView(id: $viewModel.backpack1).frame(width: width, height: height)
                }
                if viewModel.backpack2 != nil {
                    ItemView(id: $viewModel.backpack2).frame(width: width, height: height)
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
    
    private var gpmxpmView: some View {
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
    }
    
    private var shortPlayerView: some View {
        HStack {
            heroIcon
            leadingViewContainer
            Spacer()
            gpmxpmView
            itemsStackView
        }
    }
    
    @ViewBuilder private func buildAbility(abilityID: Int) -> some View {
        if let abilityName = HeroDatabase.shared.fetchAbilityName(id: abilityID) {
            if let ability = HeroDatabase.shared.fetchOpenDotaAbility(name: abilityName) {
                if let img = ability.img, ability.desc != "Associated ability not drafted, have some gold!" {
                    let parsedimgURL = img.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                    AbilityImage(viewModel: AbilityImageViewModel(name: abilityName, urlString: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)"))
                        .frame(width: 40, height: 40)
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

 struct PlayerRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayerRowView(maxDamage: 0, viewModel: .init(heroID: 2), shortVersion: true, showAbility: false)
                .environmentObject(HeroDatabase.shared)
            ScrollView(.horizontal) {
                PlayerRowView(maxDamage: 0, viewModel: .init(heroID: 2, abilities: [1123]))
                    .environmentObject(HeroDatabase.shared)
                PlayerRowView(maxDamage: 0, viewModel: .init(heroID: 3, abilities: [1123, 1124]))
                    .environmentObject(HeroDatabase.shared)
            }
                PlayerRowView(maxDamage: 0, viewModel: .init(heroID: 3), showAbility: false)
                    .environmentObject(HeroDatabase.shared)
        }
        .previewLayout(.fixed(width: 800, height: 300))
    }
 }
