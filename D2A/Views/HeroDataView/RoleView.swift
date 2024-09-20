//
//  RoleView.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2022.
//

import SwiftUI

struct RoleView: View {
    var title: String
    var level: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(LocalizedStringKey(title))
                .font(.system(size: 15))
            ProgressView(value: Float(level / 3))
                .progressViewStyle(.linear)
        }
    }
}

struct RoleView_Previews: PreviewProvider {
    static var previews: some View {
        RoleView(title: "Carry", level: 1)
    }
}
