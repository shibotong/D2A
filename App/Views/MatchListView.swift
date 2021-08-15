//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct MatchListView: View {
    @ObservedObject var vm: MatchListViewModel
    var body: some View {
            List {
                ForEach(vm.recentMatches) { match in
                    NavigationLink(destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))) {
                        MatchListRowView(vm: MatchListRowViewModel(match: match))
                    }
                }
                HStack (spacing: 10) {
                    ProgressView()
                    Text("Loading more").foregroundColor(Color(.systemGray))
                }.onAppear {
                    vm.fetchMoreData()
                }
            }
            .listStyle(InsetListStyle())
            // add refreshable in iOS 15
            .navigationTitle("Recent Matches")
            .navigationBarItems(trailing: Button(action: { vm.refresh() }) {
                Image(systemName: "arrow.clockwise")
            })
    }
}

struct MatchListRowView: View {
    @ObservedObject var vm: MatchListRowViewModel
    var body: some View {
            HStack(spacing: 10) {
                HeroIconImageView(heroID: vm.match.heroID).equatable()
                    .frame(width: 32, height: 32)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color(vm.match.win ? .systemGreen : .secondaryLabel), lineWidth: 2))
                    
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("\(vm.hero?.localizedName ?? "")").font(.custom(fontString, size: 17, relativeTo: .headline)).bold()
                        Spacer()
                        Text("\(vm.match.startTime.convertToTime())").bold().foregroundColor(Color(.secondaryLabel)).font(.caption2)
                    }
                    HStack {
                        HStack {
                            VStack(alignment: .leading) {
                                if vm.match.lobbyType == 7 {
                                    Text("Ranked").bold().foregroundColor(Color(.systemYellow)).font(.custom(fontString, size: 10, relativeTo: .caption2))
                                }
                                Text("\(vm.match.fetchMode().fetchModeName())").font(.custom(fontString, size: 13, relativeTo: .footnote))
                            }
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            KDAView(match: vm.match)
                            Spacer()
                        }
                        .frame(width: 65 )
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Duration").font(.custom(fontString, size: 10, relativeTo: .caption2)).foregroundColor(Color(.secondaryLabel))
                                Text("\(vm.match.duration.convertToDuration())")
                                    .font(.custom(fontString, size: 13, relativeTo: .footnote))
                                    .bold()
                            }
                        }.frame(width: 55)
                        
                    }
                }
            }
            .padding(.vertical, 5)
        
    }
    
}

struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView(vm: MatchListViewModel(matches: RecentMatch.sample))
        
    }
}

struct KDAView: View {
    var match: RecentMatch
    var body: some View {
        VStack(alignment: .leading) {
            Text("K/D/A").bold().foregroundColor(Color(.secondaryLabel)).font(.custom(fontString, size: 10))
            Text("\(match.kills)/\(match.deaths)/\(match.assists)").font(.custom(fontString, size: 13, relativeTo: .footnote))
        }
    }
}
