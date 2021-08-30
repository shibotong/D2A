//
//  MatchListRowView.swift
//  App
//
//  Created by Shibo Tong on 27/8/21.
//

import SwiftUI

struct MatchListRowView: View {
    @ObservedObject var vm: MatchListRowViewModel
    @EnvironmentObject var database: HeroDatabase
    var body: some View {
        HStack {
            Rectangle().frame(width: 20).foregroundColor(Color(vm.match.isPlayerWin() ? .systemGreen : .systemRed))
                .padding(.vertical, 1)
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    HeroIconImageView(heroID: vm.match.heroID)
                        .frame(width: 25, height: 25)
                    Text("\(database.fetchHeroWithID(id: vm.match.heroID)?.localizedName ?? "")").font(.custom(fontString, size: 20, relativeTo: .headline)).bold().lineLimit(1)
                }
                Text("\(vm.match.duration.convertToDuration())").font(.custom(fontString, size: 15))//.bold()
                KDAView(kills: vm.match.kills, deaths: vm.match.deaths, assists: vm.match.assists, size: 15)
            }.padding(.vertical, 5)
            Spacer()
            VStack(alignment: .trailing) {
                Text(vm.match.startTime.convertToTime()).bold()
                Text("\(vm.match.fetchMode().fetchModeName())")
                Text("\(vm.match.fetchLobby().fetchLobbyName())")
                Spacer()
                
            }.font(.custom(fontString, size: 13)).foregroundColor(Color(.systemGray3)).padding(.vertical, 5)
        }
    }
}

struct MatchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListRowView(vm: MatchListRowViewModel()).previewLayout(.fixed(width: 375, height: 80))
            .environmentObject(HeroDatabase.shared)
        MatchListRowEmptyView().previewLayout(.fixed(width: 375, height: 80))
    }
}

struct MatchListRowEmptyView: View {
    @State var loading = false
    var body: some View {
        HStack {
            Rectangle().frame(width: 20).padding(.vertical, 1)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 25, height: 25)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 25)
                }
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 50, height: 20)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 20)
            }.padding(.vertical, 5)
            Spacer()
        }
        .foregroundColor(loading ? Color(.systemGray6) : Color(.systemGray5))
        .onAppear {
            DispatchQueue.main.async {
                self.loading = true
            }
        }
        .animation(Animation.default.repeatForever())
    }
}
