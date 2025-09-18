//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import CoreData
import SwiftUI

struct PlayerProfileView: View {
    @EnvironmentObject var env: EnvironmentController
    @EnvironmentObject var gameDataController: GameDataController
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var viewContext
    @State private var isSharePresented: Bool = false

    @FetchRequest private var profile: FetchedResults<UserProfile>
    @FetchRequest private var matches: FetchedResults<RecentMatch>

    @State private var error: Bool = false
    @State private var matchLoading = false

    @State private var refreshID = UUID()
    
    @ObservedObject private var viewModel: PlayerProfileViewModel

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
        _profile = FetchRequest(
            sortDescriptors: [], predicate: NSPredicate(format: "id = %@", userid))
        let request = NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
        request.fetchLimit = 10
        request.fetchBatchSize = 1
        request.predicate = NSPredicate(format: "playerId = %@", userid)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)
        ]
        _matches = FetchRequest(fetchRequest: request)
        self.userid = userid
        viewModel = .init(userID: userid)
    }

    var favoriteButton: some View {
        ZStack {
            if let profile = viewModel.user {
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
        ScrollView {
            topBar
            HStack {
                Text("Recent Matches")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                NavigationLink(
                    destination: CalendarMatchListView(
                        vm: CalendarMatchListViewModel(userid: viewModel.userID.description))
                ) {
                    Text("All")
                }
            }
            .padding(.horizontal)
            if matchLoading {
                ProgressView()
            }
            VStack(spacing: 2) {
                ForEach(matches[0..<(matches.count > 10 ? 10 : matches.count)], id: \.id) { match in
                    NavigationLink(
                        destination: MatchView(matchid: match.matchID.description)
                    ) {
                        MatchListRowView(viewModel: MatchListRowViewModel(match: match))
                            .background(Color.systemBackground)
                    }.listRowInsets(
                        EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                }
            }
            .background(Color.secondarySystemBackground)
            .id(refreshID)
        }
        .listStyle(PlainListStyle())
        .navigationTitle(viewModel.personaname)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                favoriteButton
                    .accessibilityIdentifier("favourite")
                //                        Button {
                //                            self.isSharePresented = true
                //                        } label: {
                //                            Image(systemName: "square.and.arrow.up")
                //                        }
            }
        })
    }
    
    @ViewBuilder
    private var topBar: some View {
        if horizontalSizeClass == .compact {
            compactTopBar
        } else {
            regularTopBar
        }
    }
    
    private var compactTopBar: some View {
        VStack {
            VStack {
                avatar
                    .frame(width: 150, height: 150)
                VStack {
                    nameBar
                    subNameBar
                    userID
                    buildRank(size: 60)
                }
            }
        }
        .padding()
    }

    private var regularTopBar: some View {
        HStack(spacing: 30) {
            avatar
                .frame(width: 250, height: 250)
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        nameBar
                        subNameBar
                        userID
                    }
                    Spacer()
                    buildRank(size: 80)
                }
            }
        }
    }
    
    private var avatar: some View {
        ProfileAvatar(userID: viewModel.userID, imageURL: viewModel.imageURL, cornerRadius: 20)
    }
    
    private var nameBar: some View {
        Text(viewModel.name ?? viewModel.personaname)
            .font(.title2)
            .bold()
            .lineLimit(1)
    }
    
    private var userID: some View {
        Text("id: \(viewModel.userID.description)")
            .font(.caption)
            .foregroundColor(.secondaryLabel)
    }
    
    @ViewBuilder
    private var subNameBar: some View {
        if viewModel.name != nil {
            Text(viewModel.personaname)
                .font(.subheadline)
                .lineLimit(1)
        }
    }

    @ViewBuilder private func buildRank(size: CGFloat) -> some View {
        HStack {
            if viewModel.isPlus {
                Image("dota_plus")
                    .resizable()
                    .padding(size / 10)
                    .frame(width: size, height: size)
            }
            RankView(rank: viewModel.rank, leaderboard: viewModel.leaderboard)
                .frame(width: size, height: size)
        }
    }

    private func loadMatches() async {
        guard let userID = profile.first?.userID.description else {
            return
        }
        await setLoading(true)
        await gameDataController.refreshRecentMatches(for: userID, viewContext: viewContext)
        await setLoading(false)
    }

    @MainActor
    private func setLoading(_ state: Bool) async {
        matchLoading = state
    }
}
