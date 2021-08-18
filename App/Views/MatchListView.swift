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
    var body: some View {
        List {
            ForEach(vm.matches) { match in
                MatchListRowView(vm: MatchListRowViewModel(match: match))
            }
            Text("Load more")
                .onAppear {
                    vm.fetchMoreData()
                }
        }.navigationBarItems(trailing: Button(action: { vm.refreshData() }) {
            Image(systemName: "arrow.clockwise")
        })
        .animation(.linear)
//        if env.loadingProfile {
//            ProgressView()
//        } else {
//            if env.selectedUserProfile == nil {
//                Text("Some thing error when loading")
//            } else {
//                List {
//                    ForEach(matches) { match in
//                        NavigationLink(
//                            destination: MatchView(id: Int(match.id))){
//                                MatchListRowView(vm: MatchListRowViewModel(match: match))
//                            }.simultaneousGesture(TapGesture().onEnded{
//                                print("switch match")
//                                env.loadMatch(match: match)
//                            })
//
//                    }
//                    HStack (spacing: 10) {
//                        ProgressView()
//                        Text("Loading more").foregroundColor(Color(.systemGray))
//                    }
//                    .onAppear {
//                        env.fetchMoreData()
//                    }
//                }
//                .listStyle(InsetListStyle())
//                // add refreshable in iOS 15
//                .navigationTitle("\(env.selectedUserProfile!.profile!.personaname!)")
//                .navigationBarItems(trailing: Button(action: {  }) {
//                    Image(systemName: "arrow.clockwise")
//                })
//            }
//        }
    }
//    static func == (lhs: MatchListView, rhs: MatchListView) -> Bool {
//        return lhs.vm.userid == rhs.vm.userid
//    }
    
    
}

struct MatchListRowView: View {
    @ObservedObject var vm: MatchListRowViewModel
    var body: some View {
        HStack(spacing: 10) {
            HeroIconImageView(heroID: Int(vm.match.heroID))
                //                Image("hero_icon")
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
        MatchListView(vm: MatchListViewModel(userid: "153041957"))
        
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
