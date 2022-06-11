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
        ScrollView {
            VStack {
                HStack {
                    ProfileAvartar(url: vm.userProfile?.avatarfull ?? "", sideLength: 80, cornerRadius: 30)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vm.userProfile?.personaname ?? "")
                                .font(.title)
                                .bold()
                                .lineLimit(1)
                            if env.registerdID == vm.userid {
                                Image(systemName: "person.text.rectangle")
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
                        Text(DataHelper.transferRank(rank: vm.userProfile?.rank))
                            .foregroundColor(.secondaryLabel)
                        Text("id: \(vm.userProfile?.id.description ?? "0")")
                            .font(.caption2)
                            .foregroundColor(.tertiaryLabel)
                        
                    }
                    Spacer()
                    Image("rank_\((vm.userProfile?.rank ?? 0) / 10)")
                }
                HStack(spacing: 10) {
                    Button {
                        if env.canRefresh(userid: vm.userid ?? "") {
                            Task {
                                await vm.refreshData()
                            }
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
            }
            .padding()
            HStack {
                Text("Recent Matches")
                    .font(.custom(fontString, size: 20))
                    .bold()
                Spacer()
                Text("More")
            }
            .padding(.horizontal)
            VStack(spacing: 2) {
                ForEach(vm.matches, id: \.id) { match in
                    NavigationLink(
                        destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)")),
                        tag: "\(match.id)",
                        selection: $selectedMatch
                    ) {
                        MatchListRowView(vm: MatchListRowViewModel(match: match))
                            .background(Color.systemBackground)
                    }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                }
            }
            .background(Color.secondarySystemBackground)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("\(vm.userProfile?.personaname ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if vm.isLoading {
                ProgressView()
                    .frame(width: 50, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground))
            }
        }
    }
}



struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListView(vm: MatchListViewModel())
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
        
    }
}
