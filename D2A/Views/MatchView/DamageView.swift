//
//  DamageView.swift
//  D2A
//
//  Created by Shibo Tong on 16/12/2022.
//

import SwiftUI

struct DamageView: View {
    var maxDamage: Int
    var playerDamage: Int
    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3).frame(width: 40, height: 10)
                    .foregroundColor(Color(.secondarySystemBackground))
                RoundedRectangle(cornerRadius: 3).frame(
                    width: calculateRectangleWidth(), height: 10
                )
                .foregroundColor(.red.opacity(0.4))
            }
            Text("\(playerDamage)").font(.system(size: 10))
        }
    }

    private func calculateRectangleWidth() -> CGFloat {
        guard maxDamage == 0 else {
            return 40.0 * CGFloat(Double(playerDamage) / Double(maxDamage))
        }
        return 40.0
    }
}

// struct DamageView_Previews: PreviewProvider {
//    static var previews: some View {
//        DamageView(maxDamage: 1000, playerDamage: 900)
//    }
// }
