//
//  HeroStatsView.swift
//  D2A
//
//  Created by Shibo Tong on 31/8/2024.
//

import SwiftUI

struct HeroStatsView: View {
    
    // attack
    let attackMin: Int
    let attackMax: Int
    let attackRate: Double
    let attackRange: Int
    let projectileSpeed: Int
    
    // defence
    let armor: Double
    let magicResistance: Int
    
    // mobile
    let moveSpeed: Int
    let turnRate: Double
    let visionDay: Int
    let visionNight: Int
    
    init(attackMin: Int, attackMax: Int, attackRate: Double, attackRange: Int, projectileSpeed: Int, armor: Double, magicResistance: Int, moveSpeed: Int, turnRate: Double, visionDay: Int, visionNight: Int) {
        self.attackMin = attackMin
        self.attackMax = attackMax
        self.attackRate = attackRate
        self.attackRange = attackRange
        self.projectileSpeed = projectileSpeed
        self.armor = armor
        self.magicResistance = magicResistance
        self.moveSpeed = moveSpeed
        self.turnRate = turnRate
        self.visionDay = visionDay
        self.visionNight = visionNight
    }
    
    var body: some View {
        HStack {
            Text("Stats")
                .font(.system(size: 15))
                .bold()
            Spacer()
        }.padding(.leading)
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Attack")
                    .font(.system(size: 15))
                buildStatDetail(image: "icon_damage",
                                value: "\(attackMin)-\(attackMax)")
                buildStatDetail(image: "icon_attack_time", value: "\(attackRate)")
                buildStatDetail(image: "icon_attack_range", value: "\(attackRange)")
                buildStatDetail(image: "icon_projectile_speed", value: "\(projectileSpeed)")
            }
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Defense")
                    .font(.system(size: 15))
                buildStatDetail(image: "icon_armor", value: String(format: "%.1f", armor))
                buildStatDetail(image: "icon_magic_resist", value: "\(magicResistance)%")
            }
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text("Mobility")
                    .font(.system(size: 15))
                buildStatDetail(image: "icon_movement_speed", value: "\(moveSpeed)")
                buildStatDetail(image: "icon_turn_rate", value: "\(turnRate)")
                buildStatDetail(image: "icon_vision", value: "\(visionDay)/\(visionNight)")
            }
            Spacer()
        }
    }
    
    @ViewBuilder 
    private func buildStatDetail(image: String, value: String) -> some View {
        HStack {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(uiColor: UIColor.label))
            Text(value)
                .font(.system(size: 15))
        }
    }
}

#Preview {
    HeroStatsView(attackMin: 56, attackMax: 58, attackRate: 1.4, attackRange: 150, projectileSpeed: 0, armor: 5.7, magicResistance: 25, moveSpeed: 300, turnRate: 0.6, visionDay: 1800, visionNight: 800)
}
