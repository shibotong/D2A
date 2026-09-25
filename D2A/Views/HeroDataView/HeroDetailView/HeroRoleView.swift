//
//  HeroRoleView.swift
//  D2A
//
//  Created by Shibo Tong on 4/4/2026.
//

import SwiftUI

struct HeroRoleView: View {
    
    let carry: Int
    let disabler: Int
    let escape: Int
    let support: Int
    let jungler: Int
    let pusher: Int
    let nuker: Int
    let durable: Int
    let initiator: Int
    
    init(carry: Int, disabler: Int, escape: Int, support: Int, jungler: Int, pusher: Int, nuker: Int, durable: Int, initiator: Int) {
        self.carry = carry
        self.disabler = disabler
        self.escape = escape
        self.support = support
        self.jungler = jungler
        self.pusher = pusher
        self.nuker = nuker
        self.durable = durable
        self.initiator = initiator
    }
    
    var body: some View {
        VStack {
            HeroDetailTitleView(title: "Roles")
            Spacer()
            rolesView
            Spacer()
        }
    }
    
    private var rolesView: some View {
        HStack {
            VStack(alignment: .leading) {
                RoleView(title: "Carry", level: Double(carry))
                Spacer()
                RoleView(title: "Disabler", level: Double(disabler))
                Spacer()
                RoleView(title: "Escape", level: Double(escape))
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                RoleView(title: "Support", level: Double(support))
                Spacer()
                RoleView(title: "Jungler", level: Double(jungler))
                Spacer()
                RoleView(title: "Pusher", level: Double(pusher))
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                RoleView(title: "Nuker", level: Double(nuker))
                Spacer()
                RoleView(title: "Durable", level: Double(durable))
                Spacer()
                RoleView(title: "Initiator", level: Double(initiator))
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HeroRoleView(carry: 1, disabler: 2, escape: 3, support: 1, jungler: 2, pusher: 3, nuker: 0, durable: 1, initiator: 3)
}
