//
//  PlayerDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI

struct PlayerDetailView: View {
    var player: Player
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    Spacer()
                    HeroImgImageView(heroID: player.heroID)
                        .frame(height: 200)
                        .padding(.trailing, -30)
                }
                PlayerDetailStatView(player: player)
                
            }
        }.frame(height: 200).padding(.horizontal, 10)
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailView(player: Match.sample.players.first!)
    }
}

struct ItemBackPackView: View {
    var player: Player
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ItemView(vm: ItemViewModel(id: player.item0))
                        ItemView(vm: ItemViewModel(id: player.item1))
                        ItemView(vm: ItemViewModel(id: player.item2))
                    }
                    HStack(spacing: 0) {
                        ItemView(vm: ItemViewModel(id: player.item3))
                        ItemView(vm: ItemViewModel(id: player.item4))
                        ItemView(vm: ItemViewModel(id: player.item5))
                    }
                }
                ItemView(vm: ItemViewModel(id: player.itemNeutral)).clipShape(Circle())
            }
            HStack(spacing: 0){
                ItemView(vm: ItemViewModel(id: player.backpack0))
                ItemView(vm: ItemViewModel(id: player.backpack1))
                ItemView(vm: ItemViewModel(id: player.backpack2))
            }
        }
    }
}

struct ItemView: View {
    @ObservedObject var vm: ItemViewModel
    var body: some View {
        Image(uiImage: vm.itemImage).resizable().scaledToFit().frame(width: 40)
    }
}

struct PlayerDetailStatView: View {
    var player: Player
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ItemBackPackView(player: player)
                HStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading) {
                                Text("GPM: ")
                                Text("XPM: ")
                        }
                        VStack(alignment: .leading) {
                            Text("\(player.gpm)")
                            Text("\(player.xpm)")
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("KILLS: ")
                            Text("DEATHS: ")
                            Text("ASSISTS: ")
                        }
                        VStack (alignment: .leading) {
                            Text("\(player.kills)")
                            Text("\(player.deaths)")
                            Text("\(player.assists)")
                        }
                    }
                }.font(.custom(fontString, size: 15))
            }
            Spacer()
        }
    }
}
