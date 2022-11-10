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
        ZStack {
            if horizontalSize == .compact {
                VStack {
                    league.image.scaledToFit().clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(league.displayName ?? "")
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                }
                .padding()
            } else {
                HStack {
                    league.image.scaledToFit().clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(league.displayName ?? "")
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                }
            }
        }
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
            }.padding(.horizontal)
        }
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var description: some View {
        ZStack {
            Text(league.description ?? "")
                .lineLimit(2)
                .foregroundColor(.secondaryLabel)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button {
                        descriptionSheet.toggle()
                    } label: {
                        Text("MORE")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.label)
                    }
                    .padding([.top, .leading], 5)
                    .background {
                        RadialGradient(colors: [.systemBackground, .systemBackground.opacity(0)], center: .center, startRadius: 1, endRadius: 100)
                    }

                }
            }
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
