//
//  PlayerListView.swift
//  App
//
//  Created by Shibo Tong on 31/5/2022.
//

import SwiftUI

struct PlayerListView: View {
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        ScrollView {
            VStack {
                if env.registerdID == "" {
                    EmptyRegistedView()
                        .frame(height: 190)
                } else {
                    RegisteredPlayerView(userid: env.registerdID)
                        .frame(height: 190)
                        .background(Color.systemBackground)
                }
                VStack {
                    HStack {
                        Text("Favorite Players")
                            .font(.custom(fontString, size: 20))
                            .bold()
                        Spacer()
                    }.padding()
                    if env.userIDs.isEmpty {
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
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 140), spacing: 10, alignment: .leading), count: 1), spacing: 10) {
                            ForEach(env.userIDs, id: \.self) { id in
                                NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: id))) {
                                    PlayerListRowView(userid: id)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Home")
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


