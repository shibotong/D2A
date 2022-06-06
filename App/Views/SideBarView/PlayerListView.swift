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
                RegisteredPlayerView(vm: SidebarRowViewModel(userid: "153041957", isRegistered: true))
                    .background(Color(UIColor.systemBackground))
                RegisteredPlayerView(vm: SidebarRowViewModel(userid: "", isRegistered: true)).background(Color(UIColor.systemBackground))
                
                
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
        .environmentObject(DotaEnvironment.shared)
        .environmentObject(HeroDatabase.shared)
    }
}


struct RegisteredPlayerView: View {
    var vm: SidebarRowViewModel
    var body: some View {
            VStack {
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
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vm.profile?.personaname ?? "").font(.custom(fontString, size: 20)).bold().lineLimit(1)
                            Image("rank_\((vm.profile?.rank ?? 0) / 10)").resizable().frame(width: 18, height: 18)
                        }
                        Text("\(vm.profile?.id.description ?? "")")
                            .font(.custom(fontString, size: 15))
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
                    Spacer()
                }
                //            if let match = vm.recentMatch {
                MatchListRowView(vm: MatchListRowViewModel())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.secondarySystemBackground)))
                //            } else {
                //                Text("No recent match")
                //            }
            }
            .padding()
        
    }
}
