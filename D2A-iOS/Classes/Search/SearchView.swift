//
//  AddAccountView.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel = SearchViewModel()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.isSearching) var isSearching

    var body: some View {
        SearchResultView()
            .navigationTitle("Search")
            .searchable(
                text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Players, Heroes, Matches"
            ) {
                searchSuggestions
            }
            .disableAutocorrection(true)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search(searchText: viewModel.searchText)
                }
            }
    }

    private var searchSuggestions: some View {
        Group {
            if viewModel.searchText.isEmpty {
                EmptyView()
//                SearchHistoryView()
            } else {
                SearchSuggestionView(users: viewModel.suggestLocalProfiles,
                                     heroes: viewModel.suggestHeroes)
            }
        }.foregroundColor(.label)
    }

    private var searchPage: some View {
        ZStack {
            if viewModel.searchText.isEmpty {
//                emptySearchPage
            } else {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    searchedList
                }
            }
        }
    }

    

    private var searchedList: some View {
        List {
            if let match = viewModel.searchedMatch, let matchID = match.id {
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

            if !viewModel.filterHeroes.isEmpty {
                Section {
                    ForEach(viewModel.filterHeroes) { hero in
                        NavigationLink(
                            destination: HeroDetailViewV2(hero: hero)
                        ) {
                            HStack {
                                HeroImageViewV2(name: hero.heroNameLowerCase, type: .icon)
                                    .frame(width: 30, height: 30)
                                Text(hero.heroNameLocalized)
                            }
                        }
                    }
                } header: {
                    Text("Heroes")
                }
            }
            if !viewModel.userProfiles.isEmpty || !viewModel.searchLocalProfiles.isEmpty {
                Section {
                    ForEach(viewModel.searchLocalProfiles) { profile in
                        NavigationLink(destination: PlayerProfileView(userid: profile.id ?? "")) {
                            ProfileView(viewModel: ProfileViewModel(profile: profile))
                        }.accessibilityIdentifier(profile.id ?? "")
                    }
                    ForEach(viewModel.userProfiles) { profile in
                        NavigationLink(
                            destination: PlayerProfileView(userid: profile.id.description)
                        ) {
                            ProfileView(viewModel: ProfileViewModel(profile: profile))
                        }.accessibilityIdentifier(profile.id.description)
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
            SearchView()
        }
        .previewDevice(.iPhone)
        .previewDisplayName("iPhone")
        
        NavigationView {
            EmptyView()
            SearchView()
        }
        .previewDevice(.iPad)
        .previewDisplayName("iPad")
    }
}
