//
//  RegisteredPlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 3/12/2022.
//

import SwiftUI

struct RegisteredPlayerView: View {
    @EnvironmentObject var env: DotaEnvironment
    @FetchRequest var profile: FetchedResults<UserProfile>
    private var userID: String
    
    init(userid: String) {
        self.userID = userid
        _profile = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id == %@", userid))
    }
    
    var body: some View {
        ZStack {
            if let profile = profile.first {
                VStack(spacing: 10) {
                    NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: userID))) {
                        HStack {
                            ProfileAvartar(profile: profile, sideLength: 70, cornerRadius: 25)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(profile.personaname ?? "").font(.custom(fontString, size: 20)).bold().lineLimit(1).foregroundColor(.label)
                                Text(profile.id ?? "")
                                    .font(.custom(fontString, size: 13))
                                    .foregroundColor(Color.secondaryLabel)
                            }
                            
                            Spacer()
                            RankView(rank: Int(profile.rank), leaderboard: Int(profile.leaderboard))
                                .frame(width: 70, height: 70)
                                .padding(.trailing)
                            
                        }
                    }
//                    if let matches = vm.recentMatches {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack {
//                                ForEach(matches) { match in
//                                    VStack {
//                                        HeroImageView(heroID: match.heroID, type: .icon)
//                                        buildWL(win: match.isPlayerWin())
//                                    }
//                                }
//                            }
//                            .padding()
//                        }
//                        .frame(height: 80)
//                        .background(Color.secondarySystemBackground)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                    } else {
//                        HStack {
//                            Spacer()
//                            ProgressView()
//                            Spacer()
//                        }
//                        .frame(height: 80)
//                        .background(Color.secondarySystemBackground)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                    }
                }
                .padding(15)
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            env.deRegisterUser(userid: userID)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.label)
                        }
                        Spacer()
                    }
                }.padding()
            } else {
                ProgressView()
            }
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
                .keyboardType(.numberPad)
            Spacer()
            Button {
                Task {
                    await env.registerUser(userid: self.searchText)
                }
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

struct RegisteredPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteredPlayerView()
    }
}
