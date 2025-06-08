//
//  SectionTitle.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct SectionTitle: View {

    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .bold()
            Spacer()
        }.padding(.bottom)
    }
}
