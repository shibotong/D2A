//
//  PlayerListView.swift
//  App
//
//  Created by Shibo Tong on 31/5/2022.
//

import SwiftUI

struct PlayerListView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [],
                  predicate: NSPredicate(format: "favourite = %d AND register = %d", true, false))
    private var favouritePlayers: FetchedResults<UserProfile>
    
    var body: some View {
        ScrollView {
            VStack {
                RegisteredPlayerView()
                    .frame(height: 190)
                    .background(Color.systemBackground)
                buildFavouritePlayers()
                    .padding(.horizontal)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Home")
    }
    
    @ViewBuilder private func buildFavouritePlayers() -> some View {
        VStack {
            HStack {
                Text("Favorite Players")
                    .font(.custom(fontString, size: 20))
                    .bold()
                Spacer()
            }.padding()
            if favouritePlayers.isEmpty && env.userIDs.isEmpty {
                VStack {
                    Text("FAVORITESADDTITLE")
                        .font(.custom(fontString, size: 13))
                    Text("FAVORITESADDSUBTITLE")
                        .font(.custom(fontString, size: 13))
                    Button {
                        env.selectedTab = .search
                        env.iPadSelectedTab = .search
                    } label: {
                        HStack {
                            Spacer()
                            Text("Search Player")
                            Spacer()
                        }
                    }
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondarySystemBackground))
                }
                .padding(.vertical)
            } else if favouritePlayers.isEmpty {
                ProgressView()
                    .onAppear {
                        Task {
                            var profiles: [UserProfile] = []
                            for userid in env.userIDs {
                                guard let userProfile = try? await OpenDotaController.shared.loadUserData(userid: userid) else {
                                    continue
                                }
                                profiles.append(userProfile)
                            }
                            for profile in profiles {
                                profile.favourite = true
                            }
                            try? viewContext.save()
                            env.userIDs = []
                        }
                    }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 10, alignment: .leading), count: 1), spacing: 10) {
                    ForEach(favouritePlayers, id: \.id) { player in
                        NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: player.id ?? ""))) {
                            PlayerListRowView(profile: player)
                        }
                    }
                }
            }
        }
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(PreviewDevice.previewDevices, id: \.rawValue) { device in
                NavigationView {
                    PlayerListView()
                }
                .environmentObject(DotaEnvironment.preview)
                .environmentObject(HeroDatabase.shared)
                .previewDevice(device)
            }
        }
    }
}


