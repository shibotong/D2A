//
//  HomeView.swift
//  App
//
//  Created by Shibo Tong on 31/5/2022.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      VStack {
        RegisteredPlayerView()
          .frame(height: 170)
          .background(Color.systemBackground)
        FavouriteUserListView()
          .padding(.horizontal)
      }
    }
    .listStyle(.plain)
    .navigationTitle("Home")
  }
}

struct PlayerListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
    }
    .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
  }
}
