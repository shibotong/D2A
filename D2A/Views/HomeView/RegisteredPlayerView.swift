//
//  RegisteredPlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 3/12/2022.
//

import SwiftUI

struct RegisteredPlayerView: View {
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "register = %d", true))
    var profile: FetchedResults<UserProfile>
    
    var body: some View {
        ZStack {
            if let profile = profile.first {
                buildProfile(profile: profile)
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            deRegisterUser(user: profile)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.label)
                        }
                        Spacer()
                    }
                }.padding()
            } else if env.registerdID == "" {
                EmptyRegistedView()
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await loadRegisterUser()
                            env.registerdID = ""
                        }
                    }
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
    
    @ViewBuilder private func buildProfile(profile: UserProfile) -> some View {
        VStack(spacing: 10) {
            NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: profile.id ?? ""))) {
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
    }
    
    private func loadRegisterUser() async {
        let user = try? await OpenDotaController.shared.loadUserData(userid: env.registerdID)
        user?.favourite = true
        user?.register = true
        try? viewContext.save()
    }
    
    private func deRegisterUser(user: UserProfile) {
        user.register = false
        try? viewContext.save()
    }
}

struct EmptyRegistedView: View {
    @State var searchText: String = ""
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.managedObjectContext) private var viewContext
    
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
                    await registerUser(userid: searchText)
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
    
    private func registerUser(userid: String) async {
        do {
            let user = try await OpenDotaController.shared.loadUserData(userid: userid)
            user.register = true
            user.favourite = true
            try viewContext.save()
            return
        } catch {
            env.error = true
            env.errorMessage = "Cannot find User"
        }
    }
}

struct RegisteredPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteredPlayerView()
    }
}
