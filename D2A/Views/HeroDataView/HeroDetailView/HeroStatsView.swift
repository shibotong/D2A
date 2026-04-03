//
//  HeroStatsView.swift
//  D2A
//
//  Created by Shibo Tong on 2/4/2026.
//

import SwiftUI

struct HeroStatsView: View {
    let attackMin: Int
    let attackMax: Int
    let attackRate: Double
    let attackRange: Int
    let projectileSpeed: Int
    let armor: Double
    let baseMr: Int
    let moveSpeed: Int
    let turnRate: Double
    let visionDaytimeRange: Int
    let visionNighttimeRange: Int
    
    init(hero: Hero) {
        self.init(attackMin: Int(hero.baseAttackMin),
                  attackMax: Int(hero.baseAttackMax),
                  attackRate: hero.attackRate,
                  attackRange: Int(hero.attackRange),
                  projectileSpeed: Int(hero.projectileSpeed),
                  armor: hero.baseArmor,
                  baseMr: Int(hero.baseMr),
                  moveSpeed: Int(hero.moveSpeed),
                  turnRate: hero.turnRate,
                  visionDaytimeRange: Int(hero.visionDaytimeRange),
                  visionNighttimeRange: Int(hero.visionNighttimeRange))
    }
    
    init(attackMin: Int, attackMax: Int, attackRate: Double, attackRange: Int, projectileSpeed: Int, armor: Double, baseMr: Int, moveSpeed: Int, turnRate: Double, visionDaytimeRange: Int, visionNighttimeRange: Int) {
        self.attackMin = attackMin
        self.attackMax = attackMax
        self.attackRate = attackRate
        self.attackRange = attackRange
        self.projectileSpeed = projectileSpeed
        self.armor = armor
        self.baseMr = baseMr
        self.moveSpeed = moveSpeed
        self.turnRate = turnRate
        self.visionDaytimeRange = visionDaytimeRange
        self.visionNighttimeRange = visionNighttimeRange
    }
    
    var body: some View {
        VStack {
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
                    buildStatDetail(image: "icon_damage", value: "\(attackMin)-\(attackMax)")
                    buildStatDetail(image: "icon_attack_time", value: "\(attackRate)")
                    buildStatDetail(image: "icon_attack_range", value: "\(attackRange)")
                    buildStatDetail(image: "icon_projectile_speed", value: "\(projectileSpeed)")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Defense")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_armor", value: String(format: "%.1f", armor))
                    buildStatDetail(image: "icon_magic_resist", value: "\(baseMr)%")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Mobility")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_movement_speed", value: "\(moveSpeed)")
                    buildStatDetail(image: "icon_turn_rate", value: "\(turnRate)")
                    buildStatDetail(image: "icon_vision", value: "\(visionDaytimeRange)/\(visionNighttimeRange)")
                }
                Spacer()
            }
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
    HeroStatsView(attackMin: 100,
                  attackMax: 200,
                  attackRate: 3.1,
                  attackRange: 1000,
                  projectileSpeed: 1200,
                  armor: 1.2,
                  baseMr: 25,
                  moveSpeed: 330,
                  turnRate: 0.5,
                  visionDaytimeRange: 1200,
                  visionNighttimeRange: 1200)
}
