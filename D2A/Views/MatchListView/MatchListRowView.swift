//
//  MatchListRowView.swift
//  App
//
//  Created by Shibo Tong on 27/8/21.
//

import SwiftUI

struct MatchListRowView: View {
    @ObservedObject var vm: MatchListRowViewModel
    var body: some View {
        HStack {
            Rectangle().frame(width: 40).foregroundColor(Color(vm.match.isPlayerWin() ? .systemGreen : .systemRed))
                .overlay {
                    VStack(spacing: 0) {
                        Text(vm.match.isPlayerWin() ? "W" : "L")
                        Text("一")
                        Text("\(vm.match.duration.convertToDuration())")
                    }
                    .foregroundColor(.white)
                    .font(.caption2)
                }
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    HeroImageView(heroID: vm.match.heroID, type: .icon)
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading) {
                        KDAView(kills: vm.match.kills, deaths: vm.match.deaths, assists: vm.match.assists, size: .caption)
                        Text(LocalizedStringKey(vm.match.fetchMode().fetchModeName()))
                            .font(.caption2)
                    }
                }
            }.padding(.vertical)
            if let size = vm.match.partySize {
                buildParty(size: size)
            }
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(LocalizedStringKey(vm.match.fetchLobby().lobbyName))
                        .foregroundColor(vm.match.fetchLobby().lobbyName == "Ranked" ? Color(.systemYellow) : Color(.secondaryLabel))
                    Text(vm.match.startTime.convertToTime()).bold()
                }
            }
            .font(.caption2)
            .foregroundColor(Color(.secondaryLabel))
            .frame(width: 70)
            .padding(.trailing)
        }
    }
    
    @ViewBuilder private func buildParty(size: Int) -> some View {
        if size >= 4 {
            HStack(spacing: 2) {
                Image(systemName: "person.3.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.label)
        } else if size >= 2 {
            HStack(spacing: 2) {
                Image(systemName: "person.2.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.secondaryLabel)
        } else {
            HStack(spacing: 2) {
                Image(systemName: "person.fill")
                Text(size.description)
            }
            .font(.caption)
            .foregroundColor(.tertiaryLabel)
        }
    }
}

struct MatchListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MatchListRowView(vm: MatchListRowViewModel()).previewLayout(.fixed(width: 375, height: 70))
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
            self.loading = true
        }
        .animation(Animation.default.repeatForever(), value: loading)
    }
}
