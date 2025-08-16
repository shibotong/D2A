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

    var body: some View {
        searchPage
            .navigationTitle("Search")
            .searchable(
                text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Players, Heroes, Matches"
            ) {
                searchSuggestions
            }
            .disableAutocorrection(true)
            .onSubmit(of: .search) {
                viewModel.addSearch(viewModel.searchText)
                Task {
                    await viewModel.search(searchText: viewModel.searchText)
                }
            }
    }

    private var searchSuggestions: some View {
        Group {
            if viewModel.searchText.isEmpty {
                ForEach(viewModel.searchHistory, id: \.self) { text in
                    Label("\(text)", systemImage: "magnifyingglass")
                        .searchCompletion(text)
                }

            }
            ForEach(viewModel.suggestLocalProfiles) { profile in
                Label("\(profile.personaname ?? "")", systemImage: "person.crop.circle")
                    .searchCompletion(profile.personaname ?? "")
            }
            ForEach(viewModel.suggestHeroes) { hero in
                Label("\(hero.heroNameLocalized)", systemImage: "books.vertical.fill")
                    .searchCompletion(hero.heroNameLocalized)
            }
        }.foregroundColor(.label)
    }

    private var searchPage: some View {
        ZStack {
            if viewModel.searchText.isEmpty {
                emptySearchPage
            } else {
                if viewModel.isLoading {
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
