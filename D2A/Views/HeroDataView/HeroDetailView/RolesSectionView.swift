//
//  RolesView.swift
//  D2A
//
//  Created by Shibo Tong on 5/5/2025.
//

import SwiftUI

struct RolesSectionView: View {

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
                        buildRole(role: "Carry", roles: roles)
                        buildRole(role: "Disabler", roles: roles)
                        buildRole(role: "Escape", roles: roles)
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Support", roles: roles)
                        buildRole(role: "Jungler", roles: roles)
                        buildRole(role: "Pusher", roles: roles)
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Nuker", roles: roles)
                        buildRole(role: "Durable", roles: roles)
                        buildRole(role: "Initiator", roles: roles)
                    }.frame(width: width)
                }
                .padding(.horizontal, horizontalSpacing)
            }
            .frame(height: 120)
        }
    }
    
    
    @ViewBuilder
    private func buildRole(role: String, roles: [Role]) -> some View {
        let filteredRole = roles.first(where: { $0.roleID == role.uppercased() })
        
        let roleLevel = Double(filteredRole?.level ?? 0)
        RoleView(title: role, level: roleLevel)
    }
}

#Preview {
    RolesSectionView(roles: [Role(roleID: "Carry", level: 1)])
}
