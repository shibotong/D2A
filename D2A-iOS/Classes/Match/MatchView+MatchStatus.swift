//
//  MatchView+MatchStatus.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import SwiftUI

extension MatchViewV2 {
    struct MatchStatus: View {
        
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
        let region: Region
        let matchID: Int
        let startTime: Date
        let mode: String
        let lobby: String
        
        var body: some View {
            if horizontalSizeClass == .regular {
                HStack {
                    matchType
                    regionView
                }
                .bold()
            }
        }
        
        private var regionView: some View {
            Label(region.localizedName, systemImage: region.globeIcon)
        }
        
        private var matchType: some View {
            Text("\(lobby) / \(mode)")
        }
    }
}

#Preview {
    let context = PersistanceProvider(inMemory: true).mainContext
    var region = Region(context: context)
    region.regionID = 1
    region.name = "US WEST"
    try? context.saveChanges()
    return MatchViewV2.MatchStatus(region: region, matchID: 1000000, startTime: Date(), mode: "All Pick", lobby: "Ranked")
}
