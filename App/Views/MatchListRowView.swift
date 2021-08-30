//
//  MatchListRowView.swift
//  App
//
//  Created by Shibo Tong on 27/8/21.
//

import SwiftUI

struct MatchListRowViewV2: View {
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
        MatchListRowViewV2(vm: MatchListRowViewModel()).previewLayout(.fixed(width: 375, height: 80))
            .environmentObject(HeroDatabase.shared)
    }
}
