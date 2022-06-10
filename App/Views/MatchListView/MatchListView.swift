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
        ScrollView {
            HStack {
                ProfileAvartar(url: vm.userProfile?.avatarfull ?? "", sideLength: 80, cornerRadius: 30)
                VStack(alignment: .leading) {
                    Text(vm.userProfile?.personaname ?? "")
                        .font(.title)
                        .bold()
                    Text(DataHelper.transferRank(rank: vm.userProfile?.rank))
                        .foregroundColor(.secondaryLabel)
                    
                }
                Spacer()
                Image("rank_\((vm.userProfile?.rank ?? 0) / 10)")
            }
            HStack(spacing: 10) {
                Button {
                    Task {
                        await vm.refreshData()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Update")
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground))
                    
                }
                
                Button {
                    print("steam profile")
                } label: {
                    HStack {
                        Spacer()
                        Text("Profile")
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.primaryDota))
                    
                }
            }
            
            ForEach(vm.matches, id: \.id) { match in
                NavigationLink(
                    destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)")),
                    tag: "\(match.id)",
                    selection: $selectedMatch
                ) {
                    MatchListRowView(vm: MatchListRowViewModel(match: match))
                    
                }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
            }
            Text("Load More...")
                .onAppear {
                    withAnimation(.linear) {
                        vm.fetchMoreData()
                    }
                }
            
        }
        .listStyle(PlainListStyle())
        .navigationTitle("\(vm.userProfile?.personaname ?? "")")
        .refreshable {
            await vm.refreshData()
        }
        .onAppear {
            Task {
                await vm.refreshData()
            }
        }
        .toolbar {
            if env.registerdID == vm.userid {
                Image(systemName: "person.fill")
                    .foregroundColor(.primaryDota)
            } else {
                if env.userIDs.contains(vm.userid ?? "0") {
                    Button {
                        guard let userid = vm.userid else {
                            return
                        }
                        env.delete(userID: userid)
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.blue)
                    }
                } else {
                    Button {
                        guard let userid = vm.userid else {
                            return
                        }
                        env.addUser(userid: userid)
                    } label: {
                        Image(systemName: "star")
                            .foregroundColor(.label)
                    }
                }
            }
        }
    }
    
    static func ==(lhs: MatchListView, rhs: MatchListView) -> Bool {
        return lhs.vm.userid == rhs.vm.userid
    }
    
}



struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView(vm: MatchListViewModel())
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
        
    }
}
