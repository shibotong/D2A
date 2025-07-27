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
        if let description = ability.desc {
            if description == ability.scepter {
                buildDescription(type: .scepter, description: description)
            } else if description == ability.shard {
                buildDescription(type: .shard, description: description)
            } else {
                buildDescription(type: .none, description: description)
                if let scepter = ability.scepter {
                    buildDescription(type: .scepter, description: scepter)
                }
                if let shard = ability.shard {
                    buildDescription(type: .shard, description: shard)
                }
            }
        }
    }
    
    @ViewBuilder
    private var attributesView: some View {
        if let attributes = ability.attributes {
            VStack {
                ForEach(attributes, id: \.key) { attribute in
                    buildRow(title: attribute.header, value: attribute.value)
                }
            }
        }
    }
    
    @ViewBuilder
    private var loreView: some View {
        if let lore = ability.lore {
            Text(lore)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var scepterView: some View {
        if let scepter = ability.scepter {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image("scepter_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text("Upgraded by Scepter")
                        .font(.body)
                        .bold()
                }
                Text(scepter)
            }
        }
    }
    
    @ViewBuilder
    private var shardView: some View {
        
    }
    
    @ViewBuilder
    private func buildRow(title: String, value: String, color: Color = .label) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
            Text(value)
                .bold()
        }
    }
    
    enum AbilityDescriptionType: String {
        case shard
        case scepter
        case none
    }
    
    @ViewBuilder
    private func buildDescription(type: AbilityDescriptionType, description: String) -> some View {
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
    }
}

#if DEBUG
#Preview {
    NavigationView {
        AbilityViewV2(ability: Ability.blink)
    }
    .environmentObject(ImageController.preview)
}

#Preview {
    Text("Present modal")
        .sheet(isPresented: .constant(true)) {
            NavigationView {
                AbilityViewV2(ability: Ability.blink)
            }
            .environmentObject((ImageController.preview))
        }
}
#endif
