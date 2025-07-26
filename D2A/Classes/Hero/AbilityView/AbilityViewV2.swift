//
//  AbilityViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct AbilityViewV2: View {
    let ability: Ability
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    cdmcView
                    statsView
                    descriptionView
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.secondarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
            .padding()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                titleView
            }
        }
    }
    
    private var titleView: some View {
        HStack {
            AbilityImage(name: ability.name, urlString: ability.img)
                .frame(width: 30, height: 30)
            Text(ability.displayName ?? "")
        }
    }
    
    @ViewBuilder
    private var cdmcView: some View {
        if ability.manaCost != nil || ability.coolDown != nil {
            VStack {
                if let mc = ability.manaCost {
                    buildRow(title: "Mana Cost", value: mc)
                }
                
                if let cd = ability.coolDown {
                    buildRow(title: "Cool Down", value: cd)
                }
            }
        }
    }
    
    private var statsView: some View {
        VStack {
            if let behavior = ability.behavior {
                buildRow(title: "ABILITY", value: behavior)
            }
            if let targetTeam = ability.targetTeam {
                switch targetTeam {
                case "Both":
                    buildRow(title: "AFFECTS:", value: "Heroes")
                case "Enemy":
                    buildRow(title: "AFFECTS:", value: "Enemy Units")
                case "Friendly":
                    buildRow(title: "AFFECTS:", value: "Allied Units")
                default:
                    EmptyView()
                }
            }
            if let bkbPierce = ability.bkbPierce {
                buildRow(title: "Immunity", value: bkbPierce, color: bkbPierce == "Yes" ? .green : .label)
            }
            if let dispellable = ability.dispellable {
                buildRow(title: "Dispellable", value: dispellable, color: dispellable == "No" ? .red : .label)
            }
            if let damageType = ability.damageType {
                buildRow(title: "Damage Type", value: damageType, color: {
                    switch damageType {
                    case "Magical":
                        return .blue
                    case "Physical":
                        return .red
                    case "Pure":
                        return .yellow
                    default:
                        return .label
                    }
                }())
            }
        }
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        if let desc = ability.desc {
            Text(desc)
        }
        if let lore = ability.lore {
            Text(lore)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func buildRow(title: String, value: String, color: Color = .label) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .font(.caption)
    }
}

#if DEBUG
#Preview {
    NavigationView {
        AbilityViewV2(ability: Ability.manaBreak)
    }
    .environmentObject(ImageController.preview)
}
#endif
