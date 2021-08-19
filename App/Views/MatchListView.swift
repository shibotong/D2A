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
            ForEach(vm.matches, id: \.id) { match in
                NavigationLink(destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))) {
                    MatchListRowView(vm: MatchListRowViewModel(match: match))
                }
            }
        }
        .animation(.easeIn)
        .navigationBarItems(trailing:
            Button(action: {
                vm.refreshData()
            }, label: {
                Image(systemName: "person.fill")
            })
        )
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
