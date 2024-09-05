//
//  HeroAbilitiesScrollView.swift
//  D2A
//
//  Created by Shibo Tong on 30/8/2024.
//

import SwiftUI

//struct HeroAbilitiesScrollView: View {
//    
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    
//    @Binding var selectedAbility: Ability?
//    
//    let abilities: [Ability]
//    
//    var body: some View {
//        HStack {
//            ForEach(abilities) { ability in
//                buildAbility(ability: ability)
//            }
//        }
//    }
//    
//    @ViewBuilder 
//    private func buildAbility(ability: Ability) -> some View {
//        if horizontalSizeClass == .compact {
//            NavigationLink(destination: AbilityView(viewModel: AbilityViewModel(heroID: vm.heroID, ability: ability))) {
//                AbilityImage(viewModel: AbilityImageViewModel(name: ability.name, urlString: ability.imageURL))
//                    .frame(width: 30, height: 30)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .accessibilityIdentifier(ability.name ?? "")
//            }
//        } else {
//            Button {
//                vm.selectedAbility = ability
//            } label: {
//                AbilityImage(viewModel: AbilityImageViewModel(name: ability.name, urlString: ability.imageURL))
//                    .frame(width: 30, height: 30)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            }.accessibilityIdentifier(ability.name ?? "")
//        }
//    }
//}
//
//#Preview {
//    HeroAbilitiesScrollView(abilities: <#T##[String]#>, body: <#T##View#>)
//}
