//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: SearchViewModel = SearchViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        searchPage
            .navigationTitle("Search")
            .searchable(text: $vm.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Players, Heroes, Matches") {
                searchSuggestions
            }
            .disableAutocorrection(true)
            .onSubmit(of: .search) {
                vm.addSearch(vm.searchText)
                Task {
                    await vm.search(searchText: vm.searchText)
                }
            }
    }
    
    private var searchSuggestions: some View {
        Group {
            if vm.searchText.isEmpty {
                ForEach(vm.searchHistory, id: \.self) { text in
                    Label("\(text)", systemImage: "magnifyingglass")
                        .searchCompletion(text)
                }
                
            }
            ForEach(vm.suggestLocalProfiles) { profile in
                Label("\(profile.personaname ?? "")", systemImage: "person.crop.circle")
                    .searchCompletion(profile.personaname ?? "")
            }
            ForEach(vm.suggestHeroes) { hero in
                Label("\(hero.heroNameLocalized)", systemImage: "books.vertical.fill")
                    .searchCompletion(hero.heroNameLocalized)
            }
        }.foregroundColor(.label)
    }
    
    private var searchPage: some View {
        ZStack {
            if vm.searchText.isEmpty {
                emptySearchPage
            } else {
                if vm.isLoading {
                    ProgressView()
                } else {
                    searchedList
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
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
            if !vm.userProfiles.isEmpty || !vm.searchLocalProfiles.isEmpty {
                Section {
                    ForEach(vm.searchLocalProfiles) { profile in
                        NavigationLink(destination: PlayerProfileView(userid: profile.id ?? "")) {
                            ProfileView(viewModel: ProfileViewModel(profile: profile))
                        }
                    }
                    ForEach(vm.userProfiles) { profile in
                        NavigationLink(destination: PlayerProfileView(userid: profile.id.description)) {
                            ProfileView(viewModel: ProfileViewModel(profile: profile))
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
        }
    }
 }
