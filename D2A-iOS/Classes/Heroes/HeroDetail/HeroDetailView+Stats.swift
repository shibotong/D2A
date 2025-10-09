//
//  HeroDetailView+Stats.swift
//  D2A
//
//  Created by Shibo Tong on 9/10/2025.
//

import SwiftUI

extension HeroDetailView {

    var statsView: some View {
        buildSection(title: "Stats") {
            if horizontalSizeClass == .regular {
                HStack(alignment: .top) {
                    horizontalSection {
                        statsAttack
                    }
                    horizontalSection {
                        statsDefence
                    }
                    horizontalSection {
                        statsMobility
                    }
                }
            } else {
                Group {
                    statsAttack
                    statsDefence
                    statsMobility
                }
                .listRowSeparator(.visible)
            }
        }
    }
    
    // MARK: - Private Vars
    
    @ViewBuilder
    private var statsAttack: some View {
        statRow(title: "Attack Speed", value: "\(hero.attackRate)s")
            .listRowSeparator(.hidden, edges: .top)
        statRow(title: "Damage", value: "\(hero.calculateAttackByLevel(level: heroLevel, isMin: true)) - \(hero.calculateAttackByLevel(level: heroLevel, isMin: false))")
        statRow(title: "Attack Range", value: "\(hero.attackRange)")
    }
    
    @ViewBuilder
    private var statsDefence: some View {
        statRow(title: "Armor", value: "\(String(format: "%.1f", hero.calculateArmorByLevel(level: heroLevel)))")
        statRow(title: "Magical Resistance", value: "\(hero.baseMr)%")
    }
    
    @ViewBuilder
    private var statsMobility: some View {
        statRow(title: "Movement Speed", value: "\(hero.moveSpeed)")
        statRow(title: "Turn Rate", value: "\(hero.turnRate)")
        statRow(title: "Vision Range", value: "\(Int(hero.visionDaytimeRange))/\(Int(hero.visionNighttimeRange))")
            .listRowSeparator(.hidden, edges: .bottom)
    }
    
    @ViewBuilder
    private func statRow(title: String, value: String) -> some View {
        if horizontalSizeClass == .regular {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(.secondary)
                Text(value)
            }
        } else if horizontalSizeClass == .compact {
            HStack {
                Text(title)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
            }
        }
    }
}
