//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct AddAccountView: View {
    @EnvironmentObject var env: DotaEnvironment
    @StateObject var vm: AddAccountViewModel = AddAccountViewModel()
    var body: some View {
        NavigationView {
            buildSearchingList()
                .navigationTitle("Search")
        }
        .searchable(text: $vm.searchText, prompt: "Players, Heroes, Matches") {
            let iconWidth: CGFloat = 20
            if Int(vm.searchText) != nil {
                Label {
                    Text("Search match id \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "gamecontroller.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
                Label {
                    Text("Search player id \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
            }
            if !vm.searchText.isEmpty {
                Label {
                    Text("Search player \(vm.searchText)")
                        .font(.subheadline)
                } icon: {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(width: iconWidth)
                }
//                .searchCompletion(vm.searchText)
            }
            if !vm.searchedHeroes.isEmpty {
                Section {
                    ForEach(vm.searchedHeroes) { hero in
                        HStack {
                            HeroImageView(heroID: hero.id, type: .icon)
                                .frame(width: 30, height: 30)
                            Text(hero.localizedName)
                        }
                        .searchCompletion(hero.localizedName)
                    }
                } header: {
                    Text("Heroes")
                }
            }
        }
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
            Task {
                await vm.search(searchText: vm.searchText)
            }
        }
        
    }
    
    @ViewBuilder private func buildSearchingList() -> some View {
        if vm.searchText.isEmpty {
            VStack(spacing: 15) {
                Text("Players, Heroes, Matches")
                    .bold()
                VStack {
                    Text("Search with players id or name, ")
                        .foregroundColor(.secondaryLabel)
                    Text("hero name and match id")
                    .foregroundColor(.secondaryLabel)
                }
            }
        } else {
            List {
                if let match = vm.searchedMatch {
                    Section {
                        NavigationLink(destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))) {
                            HStack {
                                ForEach(match.fetchPlayers(isRadiant: true), id: \.heroID) { player in
                                    HeroImageView(heroID: player.heroID, type: .icon)
                                }
                                Text("vs")
                                ForEach(match.fetchPlayers(isRadiant: false), id: \.heroID) { player in
                                    HeroImageView(heroID: player.heroID, type: .icon)
                                }
                            }
                        }
                    } header: {
                        Text("Match: \(match.id.description)")
                    }
                }
                if !vm.filterHeroes.isEmpty {
                    Section {
                        ForEach(vm.filterHeroes) { hero in
                            NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                                HStack {
                                    HeroImageView(heroID: hero.id, type: .icon)
                                        .frame(width: 30, height: 30)
                                    Text(hero.localizedName)
                                }
                            }
                        }
                    } header: {
                        Text("Heroes")
                    }
                }
                if !vm.userProfiles.isEmpty {
                    Section {
                        ForEach(vm.userProfiles) { profile in
                            NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: profile.id.description))) {
                                buildProfile(profile: profile)
                            }
                        }
                    } header: {
                        Text("Players")
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    @ViewBuilder private func buildProfile(profile: UserProfile) -> some View {
        HStack {
            ProfileAvartar(url: profile.avatarfull, sideLength: 40, cornerRadius: 5)
            VStack(alignment: .leading) {
                Text(profile.personaname).bold()
                Text("ID: \(profile.id.description)")
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
            Spacer()
            if profile.id.description == env.registerdID {
                Image(systemName: "person.fill")
                    .foregroundColor(.primaryDota)
            }
            if env.userIDs.contains(profile.id.description) {
                Image(systemName: "star.fill")
            }
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
            .environmentObject(DotaEnvironment.shared)
    }
}



struct ProfileAvartar: View {
    var url: String
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
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
    }
}
