//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct MatchListView: View, Equatable {
    @EnvironmentObject var env: DotaEnvironment
    @ObservedObject var vm: MatchListViewModel
    @AppStorage("selectedMatch") var selectedMatch: String?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if vm.userid == nil {
            Text("select a user")
        } else {
            List {
                if vm.matches.isEmpty {
                    ForEach(0..<20, id:\.self) { item in
                        MatchListRowEmptyView()
                    }
                    .onAppear {
                        vm.fetchAllData()
                    }
                } else {
                if vm.refreshing {
                        HStack {
                            Spacer()
                            LoadingView()
                                .frame(width: 32, height: 32)
                            Spacer()
                        }
                    }
                    ForEach(vm.matches, id: \.id) { match in
                        NavigationLink(
                            destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)")),
                            tag: "\(match.id)",
                            selection: $selectedMatch
                        ) {
                            MatchListRowViewV2(vm: MatchListRowViewModel(match: match))
                                
                        }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                        
                    }
                    Text("Load More...")
                        .onAppear {
                            withAnimation(.linear) {
                                vm.fetchMoreData()
                            }
                        }
                    
                }
            }
//            .listStyle(PlainListStyle())
            .navigationTitle("\(vm.userProfile?.personaname ?? "")")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        withAnimation(.linear) {
                                            vm.refreshData()
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.clockwise")
                                    })
                                    .keyboardShortcut("r", modifiers: .command)
            )
        }
    }
    
    static func ==(lhs: MatchListView, rhs: MatchListView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
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
    @EnvironmentObject var database: HeroDatabase
    var body: some View {
        HStack(spacing: 10) {
            HeroIconImageView(heroID: Int(vm.match.heroID))
                .frame(width: 32, height: 32)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color(vm.match.isPlayerWin() ? .systemGreen : .secondaryLabel), lineWidth: 5))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(database.fetchHeroWithID(id: vm.match.heroID)?.localizedName ?? "")").font(.custom(fontString, size: 17, relativeTo: .headline)).bold()
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
                        KDAView(kills: vm.match.kills, deaths: vm.match.deaths, assists: vm.match.assists, size: 13)
                        Spacer()
                    }
                    .frame(width: 65)
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
        MatchListView(vm: MatchListViewModel())
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
        
    }
}
