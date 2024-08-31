////
////  HeroAttributes.swift
////  D2A
////
////  Created by Shibo Tong on 30/8/2024.
////
//
// import SwiftUI
//
// struct HeroAttributes: View {
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Attributes")
//                    .font(.system(size: 15))
//                    .bold()
//                Spacer()
//            }.padding(.bottom)
//            buildManaHealthBar(hero: hero, type: .hp)
//            buildManaHealthBar(hero: hero, type: .mana)
//            HStack {
//                Spacer()
//                buildStatLevel(hero: hero, type: .str)
//                Spacer()
//                buildStatLevel(hero: hero, type: .agi)
//                Spacer()
//                buildStatLevel(hero: hero, type: .int)
//                Spacer()
//            }
//            Slider(value: $heroLevel, in: 1...30, step: 1) {
//                Text("Level \(Int(heroLevel))")
//            } minimumValueLabel: {
//                Text("\(Int(heroLevel))")
//            } maximumValueLabel: {
//                Text("30")
//            }
//        }
//        .padding(.horizontal)
//    }
//    
//    @ViewBuilder private func buildManaHealthBar(hero: Hero, type: Hero.HeroHPMana) -> some View {
//        let total = hero.calculateHPManaByLevel(level: heroLevel, type: type)
//        let barColor = type == .hp ? Color(UIColor.systemGreen) : Color(UIColor.systemBlue)
//        VStack(spacing: 0) {
//            HStack {
//                Text(LocalizedStringKey(type.rawValue))
//                    .font(.system(size: 15))
//                    .bold()
//                    .foregroundColor(.secondaryLabel)
//                Spacer()
//                Text("\(total)")
//                    .font(.system(size: 15))
//                    .bold()
//                Text("+ \(hero.calculateHPManaRegenByLevel(level: heroLevel, type: type), specifier: "%.1f")")
//                    .font(.system(size: 13))
//            }
//            GeometryReader { proxy in
//                let rectangles = Double(total) / 250.00
//                let numberOfRect = total / 250
//                let spacer = (total % 250 == 0) ? numberOfRect : numberOfRect + 1
//                let restWidth = proxy.size.width - CGFloat(spacer)
//                let rectWidth = restWidth / rectangles
//                
//                HStack(spacing: 1) {
//                    ForEach(0..<numberOfRect, id: \.self) { _ in
//                        Rectangle()
//                            .frame(width: rectWidth)
//                    }
//                    Rectangle()
//                }
//                .frame(height: 10)
//                .foregroundColor(barColor)
//                .clipShape(Capsule())
//            }
//        }
//    }
// }
//
// #Preview {
//    HeroAttributes()
// }
