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
                                .searchCompletion(profile.id ?? "")
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
            if let selectedMatch = env.selectedMatch {
                NavigationLink(
                    destination: MatchView(matchid: selectedMatch),
                    isActive: $env.matchActive
                ) {
                    EmptyView()
                }
            }
            if let selectedUser = env.selectedUser {
                NavigationLink(
                    destination: PlayerProfileView(userid: selectedUser),
                    isActive: $env.userActive
                ) {
                    EmptyView()
                }
            }
        }
    }
    
    private var searchedList: some View {
        List {
            if let match = vm.searchedMatch, let matchID = match.id {
                Section {
                    NavigationLink(destination: MatchView(matchid: matchID)) {
                        HStack {
                            Image("icon_\(match.radiantWin ? "radiant" : "dire")")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            VStack(alignment: .leading) {
                                Text("\(match.radiantWin ? "Radiant" : "Dire") Win").bold()
                                Text(match.startTimeString)
                                    .foregroundColor(.secondaryLabel)
                                    .font(.caption)
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
                        NavigationLink(destination: PlayerProfileView(userid: profile.id ?? "")) {
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
                        NavigationLink(destination: PlayerProfileView(userid: profile.id.description)) {
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

// struct AddAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            EmptyView()
//            SearchView()
//        }.environmentObject(DotaEnvironment.shared)
//    }
// }

struct AbilityImage: View {
    var name: String
    var urlString: String
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    
    @State var image: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("profile")
                    .resizable()
            }
        }
        .frame(width: sideLength, height: sideLength)
        .task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        if let cacheImage = ImageCache.readImage(type: .ability, id: name) {
            print("Ability \(name) exist")
            Dispatch.DispatchQueue.main.async {
                image = cacheImage
            }
            return
        }
        print("Ability \(name) Doesn't exist")
        guard let newImage = await loadImage() else {
            return
        }
        ImageCache.saveImage(newImage, type: .ability, id: name)
        DispatchQueue.main.async {
            image = newImage
        }
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
