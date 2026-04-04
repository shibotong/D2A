//
//  HeroRoleView.swift
//  D2A
//
//  Created by Shibo Tong on 4/4/2026.
//

import SwiftUI

struct HeroRoleView: View {
    
    var carry: Int
    var disabler: Int
    var escape: Int
    var support: Int
    var junger: Int
    var pusher: Int
    var nuker: Int
    var durable: Int
    var initiator: Int
    
    init(hero: Hero) {
        self.init(carry: Int(hero.roleCarry), disabler: Int(hero.roleDisabler), escape: Int(hero.roleEscape),
                  support: Int(hero.roleSupport), junger: Int(hero.roleJungler), pusher: Int(hero.rolePusher),
                  nuker: Int(hero.roleNuker), durable: Int(hero.roleDurable), initiator: Int(hero.roleInitiator))
    }
    
    init(carry: Int, disabler: Int, escape: Int, support: Int, junger: Int, pusher: Int, nuker: Int, durable: Int, initiator: Int) {
        self.carry = carry
        self.disabler = disabler
        self.escape = escape
        self.support = support
        self.junger = junger
        self.pusher = pusher
        self.nuker = nuker
        self.durable = durable
        self.initiator = initiator
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Roles")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            GeometryReader { proxy in
                let horizontalSpacing: CGFloat = 32
                let verticalSpacing: CGFloat = 8
                let width = (proxy.size.width - horizontalSpacing * 4) / 3
                HStack(spacing: horizontalSpacing) {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        RoleView(title: "Carry", level: Double(carry))
                        RoleView(title: "Disabler", level: Double(disabler))
                        RoleView(title: "Escape", level: Double(escape))
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        RoleView(title: "Support", level: Double(support))
                        RoleView(title: "Jungler", level: Double(junger))
                        RoleView(title: "Pusher", level: Double(pusher))
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        RoleView(title: "Nuker", level: Double(nuker))
                        RoleView(title: "Durable", level: Double(durable))
                        RoleView(title: "Initiator", level: Double(initiator))
                    }.frame(width: width)
                }
                .padding(.horizontal, horizontalSpacing)
            }
            .frame(height: 120)
        }
    }
}

#Preview {
    HeroRoleView(carry: 1, disabler: 2, escape: 3, support: 1, junger: 2, pusher: 3, nuker: 0, durable: 1, initiator: 3)
}
