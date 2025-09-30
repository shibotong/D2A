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
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
            }
        }
        
        private var regionView: some View {
            Label("region", systemImage: regionImage(regionID: regionID))
        }
        
        private func regionImage(regionID: Int) -> String {
            switch regionID {
            case 1, 2, 10, 14, 15, 38:
                return "globe.americas.fill"
            case 3, 8, 9, 11:
                return "globe.europe.africa.fill"
            case 5, 7, 12, 13, 17, 18, 19, 20, 25, 37:
                return "globe.asia.australia.fill"
            case 6, 16:
                return "globe.central.asia.fill"
            default:
                return "globe"
            }
        }
    }
}

#Preview {
    MatchViewV2.MatchStatus(region: 1, matchID: 1000000, startTime: Date(), mode: "All Pick", lobby: "Ranked")
}
