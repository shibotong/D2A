//
//  HeroRoleView.swift
//  D2A
//
//  Created by Shibo Tong on 31/8/2024.
//

import SwiftUI

struct HeroRoleView: View {
    
    let roles: [Role]
    
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
                        buildRole(role: "Carry")
                        buildRole(role: "Disabler")
                        buildRole(role: "Escape")
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Support")
                        buildRole(role: "Jungler")
                        buildRole(role: "Pusher")
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Nuker")
                        buildRole(role: "Durable")
                        buildRole(role: "Initiator")
                    }.frame(width: width)
                }
                .padding(.horizontal, horizontalSpacing)
            }
            .frame(height: 120)
        }
    }
    
    @ViewBuilder private func buildRole(role: String) -> some View {
        let filterdRole = roles.first { $0.roleId == role.uppercased() }
        RoleView(title: role, level: filterdRole?.level ?? 0.0)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let role = Role(context: context)
    role.roleId = "CARRY"
    role.level = 2
    try? context.save()
    return HeroRoleView(roles: [role])
}
