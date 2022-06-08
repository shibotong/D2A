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
            VStack(spacing: 10) {
                if env.registerdID == "" {
                    EmptyRegistedView()
                        .frame(height: 190)
                } else {
                    RegisteredPlayerView(vm: SidebarRowViewModel(userid: env.registerdID, isRegistered: true))
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
                            Text("There are no players registered in you favorites.")
                                .font(.custom(fontString, size: 13))
                            Text("Please search and register a player.")
                                .font(.custom(fontString, size: 13))
                            Button {
                                env.selectedTab = .search
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
                        .padding()
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 110), spacing: 10, alignment: .leading), count: 3), spacing: 10) {
                            ForEach(env.userIDs, id: \.self) { id in
                                NavigationLink(destination: MatchListView(vm: MatchListViewModel(userid: id))) {
                                    PlayerListRowView(vm: SidebarRowViewModel(userid: id))
                                }
                            }
                        }
                    }
                }
                .background(Color.systemBackground)
//                VStack {
//                    HStack {
//                        Text("Gameplay Update")
//                            .font(.custom(fontString, size: 20))
//                            .bold()
//                        Spacer()
//                    }
//                    .padding()
//
//                }
//                .background(Color.systemBackground)
            }
            .background(Color(UIColor.secondarySystemBackground))
        }
        .listStyle(.plain)
        .navigationTitle("Home")
    }
    
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerListView()
        }
        .environmentObject(DotaEnvironment.preview)
        .environmentObject(HeroDatabase.shared)
    }
}

struct EmptyRegistedView: View {
    @State var searchText: String = ""
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        VStack {
            HStack {
                Text("Register Your Profile")
                    .font(.custom(fontString, size: 15))
                    .bold()
                Spacer()
            }
            TextField("Search ID", text: $searchText)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(RoundedRectangle(cornerRadius: 10).stroke().foregroundColor(.primaryDota))
            Spacer()
            Button {
                env.registerUser(userid: self.searchText)
            } label: {
                HStack {
                    Spacer()
                    Text("Register Player")
                    Spacer()
                }
            }
            .frame(height: 40)
            .background(Color.secondarySystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(Color.systemBackground)
        
    }
}

struct RegisteredPlayerView: View {
    @ObservedObject var vm: SidebarRowViewModel
    @EnvironmentObject var env: DotaEnvironment
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                NavigationLink(destination: MatchListView(vm: MatchListViewModel(userid: env.registerdID))) {
                    HStack {
                        AsyncImage(url: URL(string: vm.profile?.avatarfull ?? "")) { phase in
                            let sideLength = CGFloat(70)
                            let cornerRadius = CGFloat(25)
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: sideLength, height: sideLength)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: sideLength, height: sideLength)
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            case .failure(_):
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: sideLength, height: sideLength)
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                
                            @unknown default:
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: sideLength, height: sideLength)
                                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text(vm.profile?.personaname ?? "").font(.custom(fontString, size: 20)).bold().lineLimit(1)
                            HStack(spacing: 4) {
                                Image("rank_\((vm.profile?.rank ?? 0) / 10)").resizable().frame(width: 13, height: 13)
                                Text(DataHelper.transferRank(rank: vm.profile?.rank))
                                    .font(.custom(fontString, size: 13))
                                    .foregroundColor(Color.secondaryLabel)
                            }
                            Text("\(vm.profile?.id.description ?? "")")
                                .font(.custom(fontString, size: 13))
                                .foregroundColor(Color.secondaryLabel)
                        }
                        
                        Spacer()
                    }
                }
                if let matches = vm.recentMatches {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(matches) { match in
                                VStack {
                                    HeroImageView(heroID: match.heroID, type: .icon)
                                    buildWL(win: match.isPlayerWin())
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 80)
                    .background(Color.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(height: 80)
                    .background(Color.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .padding(15)
            .onAppear {
                vm.loadProfile()
                vm.loadMatches()
            }
            HStack {
                Spacer()
                VStack {
                    Button {
                        env.registerdID = ""
                    } label: {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                }
            }.padding()
        }
    }
    @ViewBuilder private func buildWL(win: Bool, size: CGFloat = 15) -> some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: size, height: size)
            Text("\(win ? "W" : "L")").font(.custom(fontString, size: 10)).bold().foregroundColor(.white)
        }
    }
}
