//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import CoreData

struct PlayerProfileView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var viewContext
    @State private var isSharePresented: Bool = false
    
    @FetchRequest private var profile: FetchedResults<UserProfile>
    @FetchRequest private var matches: FetchedResults<RecentMatch>
    
    private var steamLink: some View {
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
    
    private var userid: String
    
    init(userid: String) {
        _profile = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id = %@", userid))
        let request = NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
        request.fetchLimit = 10
        request.fetchBatchSize = 1
        request.predicate = NSPredicate(format: "playerId = %@", userid)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)]
        _matches = FetchRequest(fetchRequest: request)
        self.userid = userid
    }
    
    var favoriteButton: some View {
        ZStack {
            if let profile = profile.first {
                if profile.register {
                    Image(systemName: "person.text.rectangle")
                        .foregroundColor(.primaryDota)
                } else {
                    Button {
                        profile.favourite.toggle()
                        try? viewContext.save()
                    } label: {
                        Image(systemName: profile.favourite ? "star.fill" : "star")
                            .foregroundColor(profile.favourite ? .primaryDota : .label)
                    }
                }
            }
        }
    }

    var body: some View {
        if let profile = profile.first {
            buildProfileView(profile: profile)
                .listStyle(PlainListStyle())
                .navigationTitle("\(profile.personaname ?? "")")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        favoriteButton
//                        Button {
//                            self.isSharePresented = true
//                        } label: {
//                            Image(systemName: "square.and.arrow.up")
//                        }
                    }
                })
                .task {
                    await loadMatches()
                    if let profileLastUpdate = profile.lastUpdate, !profileLastUpdate.isToday {
                        await refreshUser()
                    }
                }
//                .sheet(isPresented: $isSharePresented, content: {
//                    ShareActivityView(activityItems: [SharingLink(title: "\(profile.personaname ?? "")", link: "d2aapp://profile?userid=\(profile.id.description)", image: vm.userIcon)])
//                })
        } else {
            ProgressView()
        }
    }

    @ViewBuilder private func buildProfileView(profile: UserProfile) -> some View {
        ScrollView {
            if horizontalSizeClass == .compact {
                buildCompactTopBar(profile: profile)
                    .padding(.horizontal)
            } else {
                buildRegularTopBar(profile: profile)
                    .padding()
            }
            HStack {
                Text("Recent Matches")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                NavigationLink(destination: CalendarMatchListView(vm: CalendarMatchListViewModel(userid: profile.id!))) {
                    Text("All")
                }
            }
            .padding(.horizontal)
            VStack(spacing: 2) {
                ForEach(matches[0..<(matches.count > 10 ? 10 : matches.count)], id: \.id) { match in
                    NavigationLink(
                        destination: MatchView(matchid: match.id)
                    ) {
                        MatchListRowView(match: match)
                            .background(Color.systemBackground)
                    }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                }
            }
            .background(Color.secondarySystemBackground)
        }
    }
    
    @ViewBuilder private func buildNameBar(profile: UserProfile) -> some View {
        Text(profile.name ?? profile.personaname ?? "")
            .font(.title2)
            .bold()
            .lineLimit(1)
    }
    
    @ViewBuilder private func buildCompactTopBar(profile: UserProfile) -> some View {
        VStack {
            VStack {
                ProfileAvatar(profile: profile, cornerRadius: 20)
                    .frame(width: 150, height: 150)
                VStack {
                    buildNameBar(profile: profile)
                    if profile.name != nil {
                        Text(profile.personaname ?? "")
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    Text("id: \(profile.id ?? "")")
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                    buildRank(profile: profile, size: 60)
                }
            }
            buildButton(profile: profile)
        }
        .padding()
    }
    
    @ViewBuilder private func buildRegularTopBar(profile: UserProfile) -> some View {
        HStack(spacing: 30) {
            ProfileAvatar(profile: profile, cornerRadius: 20)
                .frame(width: 250, height: 250)
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        buildNameBar(profile: profile)
                        if profile.name != nil {
                            Text(profile.personaname ?? "")
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        Text("id: \(profile.id ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondaryLabel)
                    }
                    Spacer()
                    buildRank(profile: profile, size: 80)
                }
                Spacer()
                buildButton(profile: profile)
            }
        }
    }
    
    @ViewBuilder private func buildRank(profile: UserProfile, size: CGFloat) -> some View {
        HStack {
            if profile.isPlus {
                Image("dota_plus")
                    .resizable()
                    .padding(size / 10)
                    .frame(width: size, height: size)
            }
            RankView(rank: Int(profile.rank), leaderboard: Int(profile.leaderboard))
                .frame(width: size, height: size)
        }
    }
    
    @ViewBuilder private func buildButton(profile: UserProfile) -> some View {
        HStack(spacing: 20) {
            Button {
                if env.canRefresh(userid: userid) {
                    Task {
                        await loadMatches()
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
                    steamLink
                }
            } else {
                steamLink
                    .task {
                        await refreshUser()
                    }
            }
        }
    }
    
    private func refreshUser() async {
        guard let profileCodable = try? await OpenDotaController.shared.loadUserData(userid: userid) else {
            return
        }
        _ = try? UserProfile.create(profileCodable)
    }
    
    private func loadMatches() async {
        guard let userID = profile.first?.id else {
            return
        }
        await OpenDotaController.shared.loadRecentMatch(userid: userID, lastMatch: matches.first)
    }
}
