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
                    statsSection {
                        statsAttack
                    }
                    statsSection {
                        statsDefence
                    }
                    statsSection {
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
    
    @ViewBuilder
    private var statsAttack: some View {
        statsRow(title: "Attack Speed", value: "\(hero.attackRate)s")
            .listRowSeparator(.hidden, edges: .top)
        statsRow(title: "Damage", value: "\(hero.calculateAttackByLevel(level: heroLevel, isMin: true)) - \(hero.calculateAttackByLevel(level: heroLevel, isMin: false))")
        statsRow(title: "Attack Range", value: "\(hero.attackRange)")
    }
    
    @ViewBuilder
    private var statsDefence: some View {
        statsRow(title: "Armor", value: "\(String(format: "%.1f", hero.calculateArmorByLevel(level: heroLevel)))")
        statsRow(title: "Magical Resistance", value: "\(hero.baseMr)%")
    }
    
    @ViewBuilder
    private var statsMobility: some View {
        statsRow(title: "Movement Speed", value: "\(hero.moveSpeed)")
        statsRow(title: "Turn Rate", value: "\(hero.turnRate)")
        statsRow(title: "Vision Range", value: "\(Int(hero.visionDaytimeRange))/\(Int(hero.visionNighttimeRange))")
            .listRowSeparator(.hidden, edges: .bottom)
    }
    
    @ViewBuilder
    private func statsSection<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func statsRow(title: String, value: String) -> some View {
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
