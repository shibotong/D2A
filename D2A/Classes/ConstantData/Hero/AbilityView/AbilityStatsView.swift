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
    LazyVGrid(
      columns: Array(
        repeating: GridItem(.flexible(minimum: 100, maximum: 200), spacing: 5), count: 2),
      alignment: .leading, spacing: 5
    ) {
      if let behavior {
        AbilityStatsTextView(title: "ABILITY:", message: behavior)
      }
      if let targetTeam {
        switch targetTeam {
        case "Both":
          AbilityStatsTextView(title: "AFFECTS:", message: "Heroes")
        case "Enemy":
          AbilityStatsTextView(title: "AFFECTS:", message: "Enemy Units")
        case "Friendly":
          AbilityStatsTextView(title: "AFFECTS:", message: "Allied Units")
        default:
          EmptyView()
        }
      }
      if let bkbPierce {
        AbilityStatsTextView(
          title: "IMMUNITY:", message: bkbPierce,
          color: bkbPierce == "Yes" ? .green : .label)
      }
      if let dispellable {
        AbilityStatsTextView(
          title: "DISPELLABLE:",
          message: dispellable,
          color: dispellable == "No" ? .red : Color(uiColor: UIColor.label))
      }
      if let damageType {
        AbilityStatsTextView(
          title: "DAMAGE TYPE:", message: damageType,
          color: {
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
          }())
      }
    }
  }
}

struct AbilityStatsTextView: View {

  var title: String
  var message: String
  var color: Color = .label

  var body: some View {
    HStack {
      Text(LocalizedStringKey(title))
        .font(.system(size: 11))
        .foregroundColor(.secondaryLabel)
        .lineLimit(1)
      Text(LocalizedStringKey(message))
        .font(.system(size: 11))
        .bold()
        .lineLimit(1)
        .foregroundColor(color)
    }
  }
}

struct AbilityStatsView_Previews: PreviewProvider {
  static var previews: some View {
    AbilityStatsView(
      behavior: "Point Target",
      targetTeam: "Enemy",
      bkbPierce: "Yes",
      damageType: "Magical"
    )
    .previewLayout(.fixed(width: 375, height: 300))
  }
}
