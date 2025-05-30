//
//  RegisteredPlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 3/12/2022.
//

import SwiftUI
import CoreData

struct RegisteredPlayerView: View {
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
            } else {
                EmptyRegistedView()
            }
        }
    }
    
    @ViewBuilder private func buildWL(win: Bool, size: CGFloat = 15) -> some View {
        ZStack {
            Rectangle().foregroundColor(win ? Color(.systemGreen) : Color(.systemRed))
                .frame(width: size, height: size)
            Text("\(win ? "W" : "L")").font(.system(size: 10)).bold().foregroundColor(.white)
        }
    }
    
    @ViewBuilder private func buildProfile(profile: UserProfile) -> some View {
        VStack(spacing: 10) {
            NavigationLink(destination: PlayerProfileView(userid: profile.id ?? "")) {
                HStack {
                    ProfileAvatar(profile: profile, cornerRadius: 25)
                        .frame(width: 70, height: 70)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(profile.personaname ?? "").font(.system(size: 20)).bold().lineLimit(1).foregroundColor(.label)
                        Text(profile.id ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(Color.secondaryLabel)
                    }
                    
                    Spacer()
                    RankView(rank: Int(profile.rank), leaderboard: Int(profile.leaderboard))
                        .frame(width: 70, height: 70)
                        .padding(.trailing)
                    
                }
            }
            .padding(.horizontal, 15)
            if let userid = profile.id {
                LatestRecentMatchView(userid: userid)
            }
        }
    }
    
    private func deRegisterUser(user: UserProfile) {
        user.register = false
        user.favourite = false
        try? viewContext.save()
    }
}

struct EmptyRegistedView: View {
    @State var searchText: String = ""
    @EnvironmentObject var env: DotaEnvironment
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var loading = false
    
    var body: some View {
        if loading {
            ProgressView()
        } else {
            mainBody
        }
    }
    
    private var mainBody: some View {
        VStack {
            HStack {
                Text("Register Your Profile")
                    .font(.system(size: 15))
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
                    loading = true
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
            if let profile = UserProfile.fetch(id: userid) {
                profile.favourite = true
                profile.register = true
                try viewContext.save()
            } else {
                let userCodable = try await OpenDotaController.shared.loadUserData(userid: userid)
                _ = try UserProfile.create(userCodable, favourite: true, register: true)
            }
        } catch {
            env.error = true
            env.errorMessage = "Cannot find User"
        }
        DispatchQueue.main.async {
            loading = false
        }
    }
}

struct RegisteredPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteredPlayerView()
            .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
    }
}
