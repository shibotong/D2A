//
//  AbilityViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct AbilityViewV2: View {
    
    private let name: String?
    private let isInnate: Bool
    private let displayName: String
    private let manaCost: String?
    private let coolDown: String?
    private let targetTeam: Ability.TargetTeam?
    private let behaviour: String?
    private let bkbPierce: String?
    private let dispellable: String?
    private let damageType: String?
    private let desc: String?
    private let scepter: String?
    private let shard: String?
    private let lore: String?
    private let attributes: [AbilityAttribute]
    
    private let iconSize: CGFloat = 20
    
    init(ability: Ability) {
        self.init(name: ability.name, isInnate: ability.isInnate, displayName: ability.displayName ?? "",
                  manaCost: ability.manaCost, coolDown: ability.coolDown, targetTeam: ability.target, behaviour: ability.behavior,
                  bkbPierce: ability.bkbPierce, dispellable: ability.dispellable, damageType: ability.damageType, desc: ability.desc,
                  scepter: ability.scepter, shard: ability.shard, lore: ability.lore, attributes: ability.attributes ?? [])
    }
    
    init(name: String?, isInnate: Bool, displayName: String, manaCost: String?, coolDown: String?, targetTeam: Ability.TargetTeam?, behaviour: String?, bkbPierce: String?, dispellable: String?, damageType: String?, desc: String?, scepter: String?, shard: String?, lore: String?, attributes: [AbilityAttribute]) {
        self.name = name
        self.isInnate = isInnate
        self.displayName = displayName
        self.manaCost = manaCost
        self.coolDown = coolDown
        self.targetTeam = targetTeam
        self.behaviour = behaviour
        self.bkbPierce = bkbPierce
        self.dispellable = dispellable
        self.damageType = damageType
        self.desc = desc
        self.scepter = scepter
        self.shard = shard
        self.lore = lore
        self.attributes = attributes
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Group {
                        cdmcView
                        statsView
                        attributesView
                        descriptionView
                        loreView
                    }
                    .font(.caption)
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
    }
    
    private var titleView: some View {
        HStack {
            AbilityImage(name: name, isInnate: isInnate)
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text(displayName)
                .bold()
        }
    }
    
    @ViewBuilder
    private var cdmcView: some View {
        if manaCost != nil || coolDown != nil {
            VStack {
                if let mc = manaCost {
                    buildRow(title: "Mana Cost", value: mc)
                }
                
                if let cd = coolDown {
                    buildRow(title: "Cool Down", value: cd)
                }
            }
        }
    }
    
    private var statsView: some View {
        VStack {
            if let behaviour {
                buildRow(title: "ABILITY", value: behaviour)
            }
            if let targetTeam {
                switch targetTeam {
                case .both:
                    buildRow(title: "AFFECTS:", value: "Heroes")
                case .enemy:
                    buildRow(title: "AFFECTS:", value: "Enemy Units")
                case .friendly:
                    buildRow(title: "AFFECTS:", value: "Allied Units")
                }
            }
            if let bkbPierce {
                buildRow(title: "Immunity", value: bkbPierce, color: bkbPierce == "Yes" ? .green : .label)
            }
            if let dispellable {
                buildRow(title: "Dispellable", value: dispellable, color: dispellable == "No" ? .red : .label)
            }
            if let damageType {
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
        if let description = desc {
            if description == scepter {
                buildDescription(type: .scepter, description: description)
            } else if description == shard {
                buildDescription(type: .shard, description: description)
            } else {
                buildDescription(type: .none, description: description)
                if let scepter {
                    buildDescription(type: .scepter, description: scepter)
                }
                if let shard {
                    buildDescription(type: .shard, description: shard)
                }
            }
        }
    }
    
    @ViewBuilder
    private var attributesView: some View {
        VStack {
            ForEach(attributes, id: \.key) { attribute in
                buildRow(title: attribute.header, value: attribute.value)
            }
        }
    }
    
    @ViewBuilder
    private var loreView: some View {
        if let lore {
            Text(lore)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func buildRow(title: String, value: String, color: Color = .label) -> some View {
        HeroDetailRow(title: title, value: value, color: color)
    }
    
    enum AbilityDescriptionType: String {
        case shard
        case scepter
        case none
    }
    
    @ViewBuilder
    private func buildDescription(type: AbilityDescriptionType, description: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                if type != .none {
                    HStack {
                        Image("\(type.rawValue)_1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        Text("Upgraded by \(type.rawValue)")
                            .font(.body)
                            .bold()
                    }
                }
                Text(description)
            }
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    AbilityViewV2(name: "Blink", isInnate: false, displayName: "Blink", manaCost: "20", coolDown: "20", targetTeam: .both, behaviour: "This is behaviour", bkbPierce: "Yes", dispellable: "NO", damageType: "This is damage", desc: "This is description", scepter: "This is scepter", shard: "This is shard", lore: "This is lore", attributes: [.init(key: "Attribute", header: "Header", value: "Value", generated: false)])
        .environmentObject(EnvironmentController.preview)
}
#endif
