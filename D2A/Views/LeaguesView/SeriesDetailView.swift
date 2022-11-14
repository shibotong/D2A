//
//  SeriesDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 14/11/2022.
//

import SwiftUI

struct SeriesDetailView: View {
    
    @ObservedObject var vm: SeriesDetailViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    init(matches: [LeaguesListQuery.Data.League.NodeGroup.Node.Match?]?) {
        let ids = matches?.compactMap { $0?.id } ?? []
        vm = SeriesDetailViewModel(ids: ids)
    }
    
    var body: some View {
        VStack {
            ForEach(vm.matches, id: \.id) { match in
                let iconSize: CGFloat = 30
                HStack {
                    ForEach(match.fetchPlayers(isRadiant: true), id: \.heroID) { player in
                        if horizontalSizeClass == .compact {
                            HeroImageView(heroID: player.heroID, type: .icon)
                        } else {
                            HeroImageView(heroID: player.heroID, type: .icon)
                                .frame(width: iconSize, height: iconSize)
                        }
                    }
                    Text("vs")
                    ForEach(match.fetchPlayers(isRadiant: false), id: \.heroID) { player in
                        if horizontalSizeClass == .compact {
                            HeroImageView(heroID: player.heroID, type: .icon)
                        } else {
                            HeroImageView(heroID: player.heroID, type: .icon)
                                .frame(width: iconSize, height: iconSize)
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .task {
            await vm.loadMatches()
        }
    }
}

struct SeriesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesDetailView(matches: [])
    }
}
