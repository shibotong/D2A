//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var env: DotaEnvironment
    @StateObject var vm: AddAccountViewModel = AddAccountViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        searchPage
            .navigationTitle("Search")
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Players, Heroes, Matches") {
                if !vm.searchText.isEmpty {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search \(vm.searchText)")
                        }
                        .foregroundColor(.label)
                    }
                }
                if !vm.localProfiles.isEmpty {
                    Section {
                        ForEach(vm.localProfiles) { profile in
                            ProfileView(vm: ProfileViewModel(profile: profile))
                                .searchCompletion(profile.id.description)
                                .foregroundColor(.label)
                        }
                    } header: {
                        Text("Favorite Players")
                            .foregroundColor(.secondaryLabel)
                            .font(.subheadline)
                    }
                }
                if !vm.searchedHeroes.isEmpty {
                    Section {
                        ForEach(vm.searchedHeroes) { hero in
                            HStack {
                                HeroImageView(heroID: hero.id, type: .icon)
                                    .frame(width: 30, height: 30)
                                Text(hero.heroNameLocalized)
                            }
                            .foregroundColor(.label)
                            .searchCompletion(hero.heroNameLocalized)
                        }
                    } header: {
                        Text("Heroes")
                            .foregroundColor(.secondaryLabel)
                            .font(.subheadline)
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
    
    private var searchPage: some View {
        ZStack {
            if vm.searchText.isEmpty {
                emptySearchPage
            } else {
                if vm.isLoading {
                    ProgressView()
                } else {
                    if vm.searchedMatch == nil &&
                        vm.localProfiles.isEmpty &&
                        vm.filterHeroes.isEmpty &&
                        vm.userProfiles.isEmpty {
                        Label("Cannot find any player", systemImage: "magnifyingglass")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        searchedList
                    }
                }
            }
        }
    }
    
    private var emptySearchPage: some View {
        VStack(spacing: 15) {
            Text("Players, Heroes, Matches")
                .bold()
            VStack {
                Text("Search with players id or name,")
                    .foregroundColor(.secondaryLabel)
                Text("hero name and match id")
                .foregroundColor(.secondaryLabel)
            }
            NavigationLink(
                destination: MatchView(vm: MatchViewModel(matchid: env.selectedMatch)),
                isActive: $env.matchActive
            ) {
                EmptyView()
            }
            NavigationLink(
                destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: env.selectedUser)),
                isActive: $env.userActive
            ) {
                EmptyView()
            }
        }
    }
    
    private var searchedList: some View {
        List {
            if let match = vm.searchedMatch {
                Section {
                    NavigationLink(destination: MatchView(vm: MatchViewModel(matchid: "\(match.id)"))) {
                        let iconSize: CGFloat = 30
                        HStack {
                            ForEach(match.fetchPlayers(isRadiant: true)) { player in
                                HeroImageView(heroID: Int(player.heroID), type: .icon)
                                if horizontalSizeClass == .compact {
                                    HeroImageView(heroID: Int(player.heroID), type: .icon)
                                } else {
                                    HeroImageView(heroID: Int(player.heroID), type: .icon)
                                        .frame(width: iconSize, height: iconSize)
                                }
                            }

                            Text("vs")
                            
                            ForEach(match.fetchPlayers(isRadiant: false)) { player in
                                HeroImageView(heroID: Int(player.heroID), type: .icon)
                                if horizontalSizeClass == .compact {
                                    HeroImageView(heroID: Int(player.heroID), type: .icon)
                                } else {
                                    HeroImageView(heroID: Int(player.heroID), type: .icon)
                                        .frame(width: iconSize, height: iconSize)
                                }
                            }
                            Spacer()
                        }
                    }
                } header: {
                    Text("Match: \(match.id ?? "")")
                }
            }
            if !vm.localProfiles.isEmpty {
                Section {
                    ForEach(vm.localProfiles) { profile in
                        NavigationLink(destination: PlayerProfileView(vm: PlayerProfileViewModel(userid: profile.id.description))) {
                            ProfileView(vm: ProfileViewModel(profile: profile))
                        }
                    }
                } header: {
                    Text("Favorite Players")
                }
            }
            if !vm.filterHeroes.isEmpty {
                Section {
                    ForEach(vm.filterHeroes) { hero in
                        NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: hero.id))) {
                            HStack {
                                HeroImageView(heroID: hero.id, type: .icon)
                                    .frame(width: 30, height: 30)
                                Text(hero.heroNameLocalized)
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
                            ProfileView(vm: ProfileViewModel(profile: profile))
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

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            SearchView()
        }.environmentObject(DotaEnvironment.shared)
    }
}



struct ProfileAvartar: View {
    var image: UIImage?
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: sideLength, height: sideLength)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            ProgressView()
                .frame(width: sideLength, height: sideLength)
        }
    }
}

struct AbilityImage: View {
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
