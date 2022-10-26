//
//  LiveIndicator.swift
//  D2A
//
//  Created by Shibo Tong on 26/10/2022.
//

import SwiftUI

struct LiveIndicator: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 5, height: 5)
            Text("LIVE")
                .font(.custom(fontString, size: 8))
                .bold()
        }
        .padding(5)
        .foregroundColor(.white)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.green)
        }
    }
}

struct LiveIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LiveIndicator()
    }
}
