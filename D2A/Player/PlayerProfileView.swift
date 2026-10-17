//
//  PlayerProfileView.swift
//  D2A
//
//  Created by Shibo Tong on 11/8/21.
//

import SwiftUI
import CoreData

struct PlayerProfileView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var isSharePresented: Bool = false
    
    @State private var refreshID = UUID()
    
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
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    init(userid: String) {
        viewModel = ViewModel(userID: userid)
    }
    
    var favoriteButton: some View {
        ZStack {
            if let profile = viewModel.profile {
                if profile.register {
                    Image(systemName: "person.text.rectangle")
                        .foregroundColor(.primaryDota)
                } else {
                    Button {
                        if UserProfile.canFavourite {
                            profile.favourite.toggle()
                            try? viewContext.save()
                        } else {
                            env.subscriptionSheet = true
                        }
                    } label: {
                        Image(systemName: profile.favourite ? "star.fill" : "star")
                            .foregroundColor(profile.favourite ? .primaryDota : .label)
                    }
                }
            }
        }
    }

    var body: some View {
        Group {
            if let profile = viewModel.profile {
                buildProfileView(profile: profile)
                    .listStyle(PlainListStyle())
                    .navigationTitle("\(profile.personaname ?? "")")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            favoriteButton
                                .accessibilityIdentifier("favourite")
                        }
                    })
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                try viewModel.loadUserData()
                if viewModel.profile == nil {
                    await viewModel.refreshUser()
                }
                guard let profile = viewModel.profile else {
                    return
                }
                await viewModel.loadMatches()
                if let profileLastUpdate = profile.lastUpdate, !profileLastUpdate.isToday {
                    await viewModel.refreshUser()
                }
            } catch {
                
            }
        }
        .alert(error: $viewModel.error) { _ in
            Button("OK") {
                if viewModel.profile == nil {
                    dismiss()
                }
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
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
            if viewModel.matchLoading {
                ProgressView()
            }
            VStack(spacing: 2) {
                ForEach(viewModel.matches[0..<(viewModel.matches.count > 10 ? 10 : viewModel.matches.count)], id: \.id) { match in
                    if let matchID = match.id {
                        NavigationLink(
                            destination: MatchView(matchid: matchID)
                        ) {
                            MatchListRowView(viewModel: MatchListRowViewModel(match: match))
                                .background(Color.systemBackground)
                        }.listRowInsets(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                    }
                }
            }
            .background(Color.secondarySystemBackground)
            .id(refreshID)
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
            RankView(rank: Int(truncating: profile.rank ?? 0) , leaderboard: Int(truncating: profile.rank ?? 0))
                .frame(width: size, height: size)
        }
    }
    
    @ViewBuilder private func buildButton(profile: UserProfile) -> some View {
        HStack(spacing: 20) {
            Button {
                refreshID = UUID()
                Task {
                    await viewModel.loadMatches()
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
                        await viewModel.refreshUser()
                    }
            }
        }
    }
}

#if DEBUG

private struct MockErrorGameDataFetcher: GameDataFetcher {
    func fetchUser(userID: String) async throws -> any UserProfileDTO {
        throw D2AError(category: .mock, message: "Mock Error")
    }
    
    func fetchPlayerMatches(userID: String, lastGameDate: Date?) async throws -> [any RecentMatchDTO] {
        throw D2AError(category: .mock, message: "Mock Error")
    }
}

#Preview {
    PlayerProfileView(viewModel: .init(userID: "153041957", fetcher: MockErrorGameDataFetcher()))
        .environmentObject(PreviewData.environment)
}
#endif
