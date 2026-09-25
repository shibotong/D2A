//
//  HeroDetailTitleView.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2026.
//

import SwiftUI

struct HeroDetailTitleView: View {
    
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
