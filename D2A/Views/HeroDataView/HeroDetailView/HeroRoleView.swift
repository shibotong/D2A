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
                        RoleView(title: "Jungler", level: Double(jungler))
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
    HeroRoleView(carry: 1, disabler: 2, escape: 3, support: 1, jungler: 2, pusher: 3, nuker: 0, durable: 1, initiator: 3)
}
