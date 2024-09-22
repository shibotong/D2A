//
//  AbilityViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2024.
//

import SwiftUI
import StratzAPI
import SwiftData

@available(iOS 17, *)
struct AbilityViewV2: View {
    
    let displayName: String?
    let cd: String?
    let mc: String?
    
    let abilityID: String?
    let abilityImageURL: String?
    
    let behaviour: String?
    let targetTeam: String?
    let bkbPierce: String?
    let dispellable: String?
    let damageType: String?
    
    let attributes: [StratzAttribute] = []
    let lore: String?
    
    init(ability: AbilityV2) {
        self.init(displayName: ability.dname,
                  cd: ability.cd,
                  mc: ability.mc,
                  abilityID: ability.name,
                  abilityImageURL: ability.imageURL,
                  behaviour: ability.behaviour,
                  targetTeam: ability.targetTeam,
                  bkbPierce: ability.bkbPierce,
                  dispellable: ability.dispellable,
                  damageType: ability.dmgType,
                  lore: ability.lore)
    }
    
    init(displayName: String?, cd: String?, mc: String?, abilityID: String?, abilityImageURL: String?, behaviour: String?, targetTeam: String?, bkbPierce: String?, dispellable: String?, damageType: String?, lore: String?) {
        self.displayName = displayName
        self.cd = cd
        self.mc = mc
        self.abilityID = abilityID
        self.abilityImageURL = abilityImageURL
        self.behaviour = behaviour
        self.targetTeam = targetTeam
        self.bkbPierce = bkbPierce
        self.dispellable = dispellable
        self.damageType = damageType
        self.lore = lore
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AbilityTitleView(displayName: displayName ?? "",
                                     cd: cd,
                                     mc: mc,
                                     name: abilityID,
                                     url: abilityImageURL)
                    AbilityStatsView(behavior: behaviour,
                                     targetTeam: targetTeam,
                                     bkbPierce: bkbPierce,
                                     dispellable: dispellable,
                                     damageType: damageType)
//                    if let openDota = viewModel.opentDotaAbility,
//                       let stratz = viewModel.stratzAbility {
//                        buildDescription(ability: openDota,
//                                         stratz: stratz,
//                                         proxy: proxy)
//                    }
                    
                    Spacer().frame(height: 10)
                    if !attributes.isEmpty {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(attributes, id: \.self) { item in
                                    AbilityStatsTextView(title: item.name, message: item.description)
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer().frame(height: 10)
                    if let lore {
                        Text(lore)
                            .font(.system(size: 10))
                            .padding(8)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(UIColor.tertiarySystemBackground))
                            )
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
    }
    
//    @ViewBuilder
//    private func buildDescription(description: String, type: ScepterType, proxy: GeometryProxy) -> some View {
//        VStack {
//            AbilityDescriptionView(type: type, description: description)
//        }
//    }
}

@available(iOS 17, *)
#Preview {
    AbilityViewV2(displayName: "AbilityName", cd: "10/20/30", mc: "10/20/30", abilityID: "test_ability", abilityImageURL: nil, behaviour: "test behaviour", targetTeam: "TARGET_TEAM", bkbPierce: "bkb_pierce", dispellable: "dispellable", damageType: "damage_type", lore: "Lore")
}
