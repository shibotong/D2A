//
//  MatchListView.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import CoreData
import SwiftUI

struct PlayerProfileView: View {
    @EnvironmentObject var environment: EnvironmentController
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) var context
    
    @State var user: UserProfile?
    @State var favourite: Bool = false
    
    let userID: Int
    
    init(userid: String) {
        self.userID = Int(userid)!
        user = nil
    }
    
    var body: some View {
        Group {
            if let user {
                ScrollView {
                    PlayerView(viewModel: user)
                        .padding(.horizontal)
                    //                HStack {
                    //                    Text("Recent Matches")
                    //                        .font(.system(size: 20))
                    //                        .bold()
                    //                    Spacer()
                    //                    NavigationLink(
                    //                        destination: CalendarMatchListView(
                    //                            vm: CalendarMatchListViewModel(userid: userID.description))
                    //                    ) {
                    //                        Text("All")
                    //                    }
                    //                }
                    //                .padding(.horizontal)
                    //                VStack(spacing: 2) {
                    //                    ForEach(matches[0..<(matches.count > 10 ? 10 : matches.count)], id: \.id) { match in
                    //                        NavigationLink(
                    //                            destination: MatchView(matchid: match.matchID.description)
                    //                        ) {
                    //                            MatchListRowView(viewModel: MatchListRowViewModel(match: match))
                    //                                .background(Color.systemBackground)
                    //                        }.listRowInsets(
                    //                            EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10)))
                    //                    }
                    //                }
                    //                .background(Color.secondarySystemBackground)
                    //                .id(refreshID)
                }
                .listStyle(PlainListStyle())
                .navigationTitle(user.personaname ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .title) {
                        HStack {
                            ProfileAvatar(userID: userID.description, imageURL: user.avatarfull, cornerRadius: 5)
                            Text(user.personaname ?? "")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        favoriteButton
                            .accessibilityIdentifier("favourite")
                    }
                })
            } else {
                PlayerProfileLoadingView()
            }
        }
        .task {
            await environment.refreshUser(userID: userID, context: context) { user in
                self.user = user
                self.favourite = user.favourite
            }
        }
    }
    
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
    
    var favoriteButton: some View {
        ZStack {
            Button(action: toggleUserFavourite) {
                Image(systemName: favourite ? "star.fill" : "star")
                    .foregroundColor(favourite ? .primaryDota : .label)
            }
        }
    }
    
    private func toggleUserFavourite() {
        if favourite == true {
            favourite.toggle()
            toggleUserFavourite(isFavourite: favourite)
        } else {
            if environment.canFavourite(context: context) {
                favourite.toggle()
                toggleUserFavourite(isFavourite: favourite)
            } else {
                environment.subscriptionSheet = true
            }
        }
    }
    
    private func toggleUserFavourite(isFavourite: Bool) {
        guard let user else {
            return
        }
        do {
            user.favourite = isFavourite
            try context.save()
        } catch {
            logError("Error occured when saving user: \(error)", category: .coredata)
        }
    }
}

#Preview {
    NavigationView {
        PlayerProfileView(userid: "153041957")
            .environmentObject(EnvironmentController.preview)
            .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
    }
}
