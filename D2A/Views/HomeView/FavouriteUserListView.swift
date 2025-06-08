//
//  FavouriteUserListView.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import SwiftUI

struct FavouriteUserListView: View {

  @EnvironmentObject var env: DotaEnvironment

  @Environment(\.managedObjectContext) var viewContext

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @FetchRequest(
    sortDescriptors: [],
    predicate: NSPredicate(format: "favourite = %d AND register = %d", true, false))
  private var favouritePlayers: FetchedResults<UserProfile>

  var body: some View {
    VStack {
      HStack {
        Text("Favorite Players")
          .font(.system(size: 20))
          .bold()
        Spacer()
      }.padding()
      if favouritePlayers.isEmpty {
        emptyPlayers
      } else {
        playersView
      }
    }
  }

  private var emptyPlayers: some View {
    VStack {
      Text("FAVORITESADDTITLE")
        .font(.system(size: 13))
      Text("FAVORITESADDSUBTITLE")
        .font(.system(size: 13))
      if horizontalSizeClass == .compact {
        Button {
          env.tab = .search
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
    }
    .padding(.vertical)
  }

  private var playersView: some View {
    LazyVGrid(
      columns: Array(
        repeating: GridItem(
          .adaptive(minimum: 100, maximum: 140), spacing: 10, alignment: .leading), count: 1),
      spacing: 10
    ) {
      ForEach(favouritePlayers, id: \.id) { player in
        NavigationLink(destination: PlayerProfileView(userid: player.id ?? "")) {
          UserProfileRowView(profile: player)
            .accessibilityIdentifier(player.id!.description)
        }
      }
    }
  }
}

struct FavouriteUserListView_Previews: PreviewProvider {
  static var previews: some View {
    FavouriteUserListView()
      .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
  }
}
