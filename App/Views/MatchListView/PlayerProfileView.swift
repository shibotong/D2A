//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI

struct PlayerProfileView: View {
    @EnvironmentObject var env: DotaEnvironment
    @StateObject var vm: PlayerProfileViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        if let profile = vm.userProfile {
            ScrollView {
                if horizontalSizeClass == .compact {
                    buildCompactTopBar(profile: profile)
                } else {
                    buildRegularTopBar(profile: profile)
                        .padding()
                }
                HStack {
                    Text("Recent Matches")
                        .font(.custom(fontString, size: 20))
                        .bold()
                    Spacer()
                    NavigationLink(destination: CalendarMatchListView(vm: CalendarMatchListViewModel(userid: self.vm.userid!))) {
                        Text("More")
                    }
                }
                .padding(.horizontal)
                VStack(spacing: 2) {
                    ForEach(vm.matches, id: \.id) { match in
                        NavigationLink(
                            destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))
                        ) {
                            MatchListRowView(vm: MatchListRowViewModel(match: match))
                                .background(Color.systemBackground)
                        }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                    }
                }
                .background(Color.secondarySystemBackground)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("\(profile.personaname)")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if vm.isLoading {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground))
                }
            }
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder private func buildNameBar(profile: UserProfile) -> some View {
        
        HStack {
            Text(profile.name ?? profile.personaname)
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
                        env.addOrDeleteUser(userid: userid, profile: profile)
                    } label: {
                        Image(systemName: "star")
                            .foregroundColor(.label)
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder private func buildCompactTopBar(profile: UserProfile) -> some View {
        VStack {
            VStack {
                ProfileAvartar(url: profile.avatarfull, sideLength: 150, cornerRadius: 20)
                VStack {
                    buildNameBar(profile: profile)
                    if profile.name != nil {
                        Text(profile.personaname)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    Text("id: \(profile.id.description)")
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                    buildRank(profile: profile)
                }
            }
            buildButton(profile: profile)
        }
        .padding()
    }
    
    @ViewBuilder private func buildRegularTopBar(profile: UserProfile) -> some View {
        HStack(spacing: 30) {
            ProfileAvartar(url: profile.avatarfull, sideLength: 250, cornerRadius: 20)
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        buildNameBar(profile: profile)
                        if profile.name != nil {
                            Text(profile.personaname)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        Text("id: \(profile.id.description)")
                            .font(.caption)
                            .foregroundColor(.secondaryLabel)
                    }
                    Spacer()
                    buildRank(profile: profile)
                }
                Spacer()
                buildButton(profile: profile)
            }
        }
    }
    
    @ViewBuilder private func buildRank(profile: UserProfile) -> some View {
        HStack {
            if profile.isPlus ?? false {
                Image("dota_plus")
                    .resizable()
                    .padding()
                    .frame(width: 80, height: 80)
            }
            RankView(rank: profile.rank, leaderboard: profile.leaderboard)
                .frame(width: 80, height: 80)
        }
    }
    
    @ViewBuilder private func buildButton(profile: UserProfile) -> some View {
        HStack(spacing: 25) {
            Button {
                if env.canRefresh(userid: vm.userid ?? "") {
                    Task {
                        await vm.refreshData(refreshAll: true)
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .font(Font.system(size: 15, weight: .semibold))
                    Text("Update")
                        .font(Font.system(size: 15, weight: .semibold))
                    Spacer()
                }
                .frame(height: 45)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground))
                
            }
            if let url = URL(string: profile.profileurl ?? "") {
                Link(destination: url) {
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .font(Font.system(size: 15, weight: .semibold))
                        Text("Profile")
                            .font(Font.system(size: 15, weight: .semibold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(height: 45)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.primaryDota))
                }
            }
        }
    }
}



struct MatchListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProfileView(vm: PlayerProfileViewModel())
            .environmentObject(DotaEnvironment.shared)
            .environmentObject(HeroDatabase.shared)
        //            .preferredColorScheme(.dark)
        
    }
}
