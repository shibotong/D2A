//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct MatchListView: View {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: MatchListViewModel
    @AppStorage("selectedMatch") var selectedMatch: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if vm.userid == nil {
            Text("select a user")
        } else {
            VStack {
                if vm.refreshing {
                    LoadingView().frame(height: 30)
                }
                List {
                    if vm.matches.isEmpty {
                        ForEach(0..<20, id:\.self) { item in
                            MatchListRowEmptyView()
                        }
                        .onAppear {
                            vm.fetchAllData()
                        }
                    } else {
                        
                        ForEach(vm.matches, id: \.id) { match in
                            if horizontalSizeClass == .compact {
                                NavigationLink(
                                    destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)")),
                                    tag: "\(match.id)",
                                    selection: $selectedMatch
                                ) {
                                    MatchListRowView(vm: MatchListRowViewModel(match: match))
                                }
                            } else {
                                Button(action: {
                                    self.selectedMatch = "\(match.id)"
                                }) {
                                    MatchListRowView(vm: MatchListRowViewModel(match: match))
                                }
                            }
                        }
                        Text("Load More...")
                            .onAppear {
                                withAnimation(.default) {
                                    vm.fetchMoreData()
                                }
                            }
                    }
                }
                
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        withAnimation(.default) {
                                            vm.refreshData()
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.counterclockwise")
                                    })
            )
        }
    }
}

struct MatchListRowEmptyView: View {
    @State var loading = false
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 15).frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    RoundedRectangle(cornerRadius: 5).frame(width: 200, height: 17)
                    Spacer()
                }
                HStack {
                    RoundedRectangle(cornerRadius: 5).frame(width: 60, height: 28)
                    Spacer()
                    RoundedRectangle(cornerRadius: 5).frame(width: 60, height: 28)
                    Spacer()
                    RoundedRectangle(cornerRadius: 5).frame(width: 60, height: 28)
                }
            }
        }
        .foregroundColor(loading ? Color(.systemGray6) : Color(.systemGray5))
        .onAppear {
            self.loading = true
        }
        .animation(Animation.default.repeatForever())
    }
}

struct MatchListRowView: View {
    @ObservedObject var vm: MatchListRowViewModel
    var body: some View {
        HStack(spacing: 10) {
            HeroIconImageView(heroID: Int(vm.match.heroID))
                .frame(width: 32, height: 32)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color(vm.match.isPlayerWin() ? .systemGreen : .secondaryLabel), lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(vm.hero?.localizedName ?? "")").font(.custom(fontString, size: 17, relativeTo: .headline)).bold()
                    Spacer()
                    Text("\(Int(vm.match.startTime).convertToTime())").bold().foregroundColor(Color(.secondaryLabel)).font(.caption2)
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
                            Text("\(Int(vm.match.duration).convertToDuration())")
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
        MatchListRowEmptyView()
        
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
