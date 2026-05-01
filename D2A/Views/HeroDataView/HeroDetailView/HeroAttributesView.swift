//
//  HeroAttributesView.swift
//  D2A
//
//  Created by Shibo Tong on 25/4/2026.
//

import SwiftUI

struct HeroAttributesView: View {
    
    let hp: Int
    let hpRegen: Double
    let mana: Int
    let manaRegen: Double
    
    let strength: Int
    let agility: Int
    let intelligence: Int
    
    let gainStr: Double
    let gainAgi: Double
    let gainInt: Double
    
    init(level: Int, hero: Hero) {
        let level = Double(level)
        self.init(hp: hero.calculateHPLevel(level: level),
                  hpRegen: hero.calculateHPRegen(level: level),
                  mana: hero.calculateManaLevel(level: level),
                  manaRegen: hero.calculateMPRegen(level: level),
                  strength: hero.calculateAttribute(level: level, attr: .str),
                  agility: hero.calculateAttribute(level: level, attr: .agi),
                  intelligence: hero.calculateAttribute(level: level, attr: .int),
                  gainStr: hero.gainStr, gainAgi: hero.gainAgi, gainInt: hero.gainInt)
    }
    
    init(hp: Int, hpRegen: Double, mana: Int, manaRegen: Double, strength: Int, agility: Int, intelligence: Int, gainStr: Double, gainAgi: Double, gainInt: Double) {
        self.hp = hp
        self.hpRegen = hpRegen
        self.mana = mana
        self.manaRegen = manaRegen
        self.strength = strength
        self.agility = agility
        self.intelligence = intelligence
        self.gainStr = gainStr
        self.gainAgi = gainAgi
        self.gainInt = gainInt
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Attributes")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.bottom)
            VStack(spacing: 0) {
                HStack {
                    Text("Health")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(hp)")
                        .font(.system(size: 15))
                        .bold()
                    Text("+ \(hpRegen, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                buildManaHealthBar(total: hp, color: Color(UIColor.systemGreen))
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Mana")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(mana)")
                        .font(.system(size: 15))
                        .bold()
                    Text("+ \(manaRegen, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                
                buildManaHealthBar(total: mana, color: Color(UIColor.systemBlue))
            }
            
            HStack {
                Spacer()
                HStack {
                    Image("attribute_str")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(strength)")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(gainStr, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
                HStack {
                    Image("attribute_agi")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(agility)")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(gainAgi, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
                HStack {
                    Image("attribute_int")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(intelligence)")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(gainInt, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func buildManaHealthBar(total: Int, color: Color) -> some View {
        GeometryReader { proxy in
            let rectangles = Double(total) / 250.00
            let numberOfRect = total / 250
            let spacer = (total % 250 == 0) ? numberOfRect : numberOfRect + 1
            let restWidth = proxy.size.width - CGFloat(spacer)
            let rectWidth = restWidth / rectangles
            
            HStack(spacing: 1) {
                ForEach(0..<numberOfRect, id: \.self) { _ in
                    Rectangle()
                        .frame(width: rectWidth)
                }
                Rectangle()
            }
            .frame(height: 10)
            .foregroundColor(color)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    HeroAttributesView(hp: 250, hpRegen: 1.0, mana: 500, manaRegen: 2.0, strength: 10, agility: 24, intelligence: 13, gainStr: 1.5, gainAgi: 2.3, gainInt: 1.8)
}
