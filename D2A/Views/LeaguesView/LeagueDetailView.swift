//
//  LeagueDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import SwiftUI

struct LeagueDetailView: View {
    
    var league: League
    
    @Environment (\.horizontalSizeClass) private var horizontalSize
    @State var descriptionSheet: Bool = false
    
    var banner: some View {
        league.image.scaledToFit().clipShape(RoundedRectangle(cornerRadius: 5)).padding()
    }
        
    var body: some View {
        ScrollView {
            VStack {
                banner
                    .frame(height: 200)
                    .ignoresSafeArea()
                    .clipped()
                description
                Spacer().frame(height: 20)
                if let liveMatches = league.liveMatches, !liveMatches.isEmpty {
                    buildLiveMatches(matches: liveMatches.compactMap { $0 }.filter { $0.completed == false })
                }
                if let nodeGroupsOptional = league.nodeGroups, let nodeGroups = nodeGroupsOptional.compactMap { $0 } {
                    ForEach(nodeGroups, id: \.id) { nodeGroup in
                        if let nodesOptional = nodeGroup.nodes, let nodes = nodesOptional.compactMap { $0 }, nodes.count != 0 {
                            Section {
                                ForEach(nodes, id: \.id) { node in
//                                    NavigationLink(destination: SeriesDetailView(matches: node.matches?.compactMap {$0})) {
                                        SeriesItem(series: node)
//                                    }
                                }
                            } header: {
                                Text(nodeGroup.name ?? " ")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $descriptionSheet) {
            NavigationView {
                ScrollView {
                    Text(league.description ?? "").padding(.horizontal)
                }
                .navigationTitle(league.displayName ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button {
                            descriptionSheet.toggle()
                        } label: {
                            Text("Done")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
        .navigationTitle(league.displayName ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var description: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.secondarySystemBackground)
            Text(league.description ?? "")
                .foregroundColor(.secondaryLabel)
                .padding()
        }
    }
    
    @ViewBuilder private func buildLiveMatches(matches: [LeagueLiveMatch]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Live")
            ForEach(matches, id:\.matchId) { match in
                if let matchID = match.matchId, let parsing = match.isParsing {
                    MatchLiveRowView(matchID: matchID, isParsing: parsing)
                }
            }
        }
    }
}
