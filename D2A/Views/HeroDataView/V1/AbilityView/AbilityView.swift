//
//  AbilityViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import SwiftUI

enum ScepterType: String {
    case scepter
    case shard
    case non
    
    var upgradeString: LocalizedStringKey {
        switch self {
        case .scepter:
            return LocalizedStringKey("SCEPTER UPGRADE")
        case .shard:
            return LocalizedStringKey("SHARD UPGRADE")
        case .non:
            return LocalizedStringKey("")
        }
    }
}

struct AbilityView: View {
    
    private let ability: Ability
    private let localisation: AbilityLocalisation?
    private let heroName: String
    
    init(ability: Ability,
         language: String = languageCode.rawValue,
         heroName: String) {
        self.ability = ability
        self.localisation = ability.localisation(language: language)
        self.heroName = heroName
    }
    
    var body: some View {
        ScrollView {
            VStack {
                title
                stats
                descriptions
                if let lore = localisation?.lore {
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
            .padding()
        }
    }
    
    private var title: some View {
        AbilityTitleView(displayName: localisation?.displayName ?? "",
                         cd: ability.cd,
                         mc: ability.mc,
                         name: ability.name,
                         url: ability.imageURL)
    }
    
    private var stats: some View {
        AbilityStatsView(behavior: ability.behaviour,
                         targetTeam: ability.targetTeam,
                         bkbPierce: ability.bkbPierce,
                         dispellable: ability.dispellable,
                         damageType: ability.dmgType)
    }
    
    private var descriptions: some View {
        VStack {
            if let description = localisation?.abilityDescription {
                AbilityDescriptionView(type: .non, description: description, name: ability.name, heroName: heroName)
            }
            
            if let scepter = localisation?.scepter {
                Divider()
                AbilityDescriptionView(type: .scepter, description: scepter, name: ability.name, heroName: heroName)
            }
            
            if let shard = localisation?.shard {
                Divider()
                AbilityDescriptionView(type: .shard, description: shard, name: ability.name, heroName: heroName)
            }
        }
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let ability = Ability(context: previewContext)
    ability.name = "antimage_mana_break"
    ability.abilityID = 1
    ability.mc = "10"
    
    let localisation = AbilityLocalisation(language: "ENGLISH", displayName: "Antimage Mana Break", lore: "A modified technique of the Turstarkuri monks' peaceful ways is to turn magical energies on their owner.", description: "Burns an opponent's mana on each attack and deals damage equal to a percentage of the mana burnt. Enemies with no mana left are temporarily slowed.")
    ability.localisations = [localisation]
    return AbilityView(ability: ability, language: "ENGLISH", heroName: "antimage")
}
