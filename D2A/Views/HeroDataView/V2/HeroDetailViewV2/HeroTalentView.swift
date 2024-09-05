//
//  HeroTalentView.swift
//  D2A
//
//  Created by Shibo Tong on 31/8/2024.
//

import SwiftUI
//
//struct HeroTalentView: View {
//    
//    let talents: [Talent]
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Talents")
//                    .font(.system(size: 15))
//                    .bold()
//                Spacer()
//            }.padding(.leading)
//            buildLevelTalent(talent: talents, level: 4)
//            Divider()
//            buildLevelTalent(talent: talents, level: 3)
//            Divider()
//            buildLevelTalent(talent: talents, level: 2)
//            Divider()
//            buildLevelTalent(talent: talents, level: 1)
//        }
//    }
//    
//    @ViewBuilder
//    private func buildLevelTalent(talent: [Talent], level: Int) -> some View {
//        GeometryReader { proxy in
//            HStack(spacing: 5) {
//                if let leftSideTalent = talent.first(where: { $0.slot == level * 2 - 1 }) {
//                    let abilityId = leftSideTalent.abilityId
//                    Text(vm.fetchTalentName(id: abilityId))
//                        .font(.system(size: 10))
//                        .frame(width: (proxy.size.width - 40) / 2)
//                } else {
//                    Text("No Talent")
//                }
//                Text("\(5 + 5 * level)")
//                    .font(.system(size: 10))
//                    .bold()
//                    .padding(5)
//                    .frame(width: 30, height: 30)
//                    .background(Circle().stroke().foregroundColor(.yellow))
//                if let rightSideTalent = talent.first(where: { $0.slot == level * 2 - 2 }) {
//                    let abilityId = rightSideTalent.abilityId
//                    Text(vm.fetchTalentName(id: abilityId))
//                        .font(.system(size: 10))
//                        .frame(width: (proxy.size.width - 30) / 2)
//                } else {
//                    Text("No Talent")
//                }
//            }
//        }
//        .frame(height: 30)
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    HeroTalentView()
//}
