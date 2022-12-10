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
                    .frame(height: 190)
                    .background(Color.systemBackground)
                buildFavouritePlayers()
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
                    HomeView()
                }
                .previewDevice(device)
            }
        }
    }
}


