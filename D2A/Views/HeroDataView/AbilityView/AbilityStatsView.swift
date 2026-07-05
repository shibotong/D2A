//
//  AbilityStatsView.swift
//  D2A
//
//  Created by Shibo Tong on 21/1/2024.
//

import SwiftUI

struct AbilityStatsView: View {
    
    var behavior: String?
    var targetTeam: String?
    var bkbPierce: String?
    var dispellable: String?
    var damageType: String?
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4), count: 2), alignment: .leading, spacing: 16) {
            if let behavior {
                AbilityStatsTextView(title: "ABILITY:", message: behavior, isHorizontal: false)
            }
            if let targetTeam {
                switch targetTeam {
                case "Both":
                    AbilityStatsTextView(title: "AFFECTS:", message: "Heroes", isHorizontal: false)
                case "Enemy":
                    AbilityStatsTextView(title: "AFFECTS:", message: "Enemy Units", isHorizontal: false)
                case "Friendly":
                    AbilityStatsTextView(title: "AFFECTS:", message: "Allied Units", isHorizontal: false)
                default:
                    EmptyView()
                }
            }
            if let bkbPierce {
                AbilityStatsTextView(title: "IMMUNITY:", message: bkbPierce, color: bkbPierce == "Yes" ? .green : .label, isHorizontal: false)
            }
            if let dispellable {
                AbilityStatsTextView(title: "DISPELLABLE:",
                                     message: dispellable,
                                     color: dispellable == "No" ? .red : Color(uiColor: UIColor.label),
                                     isHorizontal: false)
            }
            if let damageType {
                AbilityStatsTextView(title: "DAMAGE TYPE:", message: damageType, color: {
                    switch damageType {
                    case "Magical":
                        return .blue
                    case "Physical":
                        return .red
                    case "Pure":
                        return .yellow
                    default:
                        return .label
                    }
                }(), isHorizontal: false)
            }
        }
    }
}

struct AbilityStatsTextView: View {
    
    let title: String
    let message: String
    let color: Color
    let isHorizontal: Bool
    
    init(title: String, message: String, color: Color = .label, isHorizontal: Bool = true) {
        self.title = title
        self.message = message
        self.color = color
        self.isHorizontal = isHorizontal
    }
    
    var body: some View {
        if isHorizontal {
            HStack {
                texts
            }
        } else {
            VStack(alignment: .leading) {
                texts
            }
        }
    }
    
    private var texts: some View {
        Group {
            Text(LocalizedStringKey(title))
                .font(.body)
                .foregroundColor(.secondaryLabel)
                .lineLimit(1)
            Text(LocalizedStringKey(message))
                .font(.body)
                .bold()
                .lineLimit(1)
                .foregroundColor(color)
        }
    }
}

struct AbilityStatsView_Previews: PreviewProvider {
    static var previews: some View {
        AbilityStatsView(behavior: "Point Target",
                         targetTeam: "Enemy",
                         bkbPierce: "Yes",
                         damageType: "Magical")
        .previewLayout(.fixed(width: 375, height: 300))
    }
}
