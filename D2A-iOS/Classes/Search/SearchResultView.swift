//
//  SearchResultView.swift
//  D2A
//
//  Created by Shibo Tong on 22/8/2025.
//

import SwiftUI

struct SearchResultView: View {
    @Environment(\.isSearching) var isSearching
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var viewModel: SearchViewModel
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.searchTime)])
    var searchHistories: FetchedResults<SearchHistory>
    
    @State private var clearSearchDialogIsPresented = false
    
    private let imageSize: CGFloat = 40
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if !viewModel.heroes.isEmpty || !viewModel.localProfiles.isEmpty {
            suggestions
        } else if isSearching && !searchHistories.isEmpty {
            searchHistoryPage
        } else {
            emptySearchPage
        }
    }
    
    private var suggestions: some View {
        List {
            if let match = viewModel.searchedMatch, let matchID = match.id {
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
            }
            ForEach(viewModel.heroes) { hero in
                NavigationLink(destination: HeroDetailViewV2(hero: hero)) {
                    HStack {
                        HeroImageViewV2(hero: hero, type: .icon)
                            .frame(width: imageSize)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        buildTitle(title: hero.heroNameLocalized, subTitle: "Hero")
                    }
                }
                .onTapGesture {
                    addSeaarch(item: hero)
                }
            }
            ForEach(viewModel.localProfiles) { profile in
                NavigationLink(destination: Text("PlayerProfileView")) {
                    HStack {
                        ProfileAvatar(profile: profile, cornerRadius: 5)
                            .frame(width: imageSize)
                        buildTitle(title: profile.personaname ?? "Unknown", subTitle: profile.id ?? "")
                    }
                }
                .onTapGesture {
                    addSeaarch(item: profile)
                }
            }
            ForEach(viewModel.remoteProfiles) { profile in
                NavigationLink(destination: PlayerProfileView(userid: profile.id.description)) {
                    ProfileView(viewModel: ProfileViewModel(profile: profile))
                }
                .onTapGesture {
                    addSeaarch(item: profile)
                }
            }
        }
        .listStyle(.plain)
        .foregroundColor(.label)
    }
    
    private var emptySearchPage: some View {
        VStack(spacing: 15) {
            Text(LocalizableStrings.searchPageTitle)
                .bold()
            VStack {
                Text(LocalizableStrings.searchPageSubtitle)
                    .foregroundColor(.secondaryLabel)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchHistoryPage: some View {
        List {
            Section {
                ForEach(searchHistories) { history in
                    Group {
                        if let hero = history.hero {
                            NavigationLink(destination: HeroDetailViewV2(hero: hero)) {
                                SearchHeroRowView(hero: hero)
                                
                            }
                        }
                        if let user = history.player {
                            NavigationLink(destination: PlayerProfileView(userid: user.id ?? "")) {
                                ProfileView(viewModel: ProfileViewModel(profile: user))
                                
                            }
                        }
                        if let match = history.match {
                            NavigationLink(destination: MatchView(matchid: match.id ?? "")) {
                                HStack {
                                    Image("icon_\(match.radiantWin ? "radiant" : "dire")")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    VStack(alignment: .leading) {
                                        Text("\(match.id ?? "")").bold()
                                        Text(match.startTimeString)
                                            .foregroundColor(.secondaryLabel)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        searchClicked(history: history)
                    }
                }
            } header: {
                HStack {
                    Text(LocalizableStrings.recentlySearched)
                        .bold()
                    Spacer()
                    Button {
                        clearSearchDialogIsPresented = true
                    } label: {
                        Text(LocalizableStrings.clear)
                            .bold()
                    }
                }
            }
        }
        .listStyle(.plain)
        .confirmationDialog(LocalizableStrings.clearSearchTitle, isPresented: $clearSearchDialogIsPresented, titleVisibility: .visible) {
            Button(LocalizableStrings.clearSearchButton, role: .destructive, action: clearSearch)
            Button(LocalizableStrings.cancel, role: .cancel) {
                clearSearchDialogIsPresented = false
            }
        } message: {
            Text(LocalizableStrings.clearSearchDescription)
        }
    }
    
    @ViewBuilder
    private func buildTitle(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(subTitle)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryLabel)
        }
    }
    
    private func searchClicked(history: SearchHistory) {
        history.searchTime = Date()
        do {
            try context.save()
        } catch {
            logError("not able to update search history. \(error.localizedDescription)", category: .coredata)
        }
    }
    
    private func clearSearch() {
        for search in searchHistories {
            context.delete(search)
        }
        do {
            try context.save()
        } catch {
            logError("Failed to batch delete search histories: \(error)", category: .coredata)
        }
    }
    
    private func addSeaarch(item: Any) {
        let searchHistory = SearchHistory(context: context)
        searchHistory.searchTime = Date()
        if let user = item as? UserProfile {
            searchHistory.player = user
        } else if let hero = item as? Hero {
            searchHistory.hero = hero
        } else if let match = item as? Match {
            searchHistory.match = match
        } else {
            logError("search item is not supported", category: .coredata)
            return
        }
        do {
            try context.save()
        } catch {
            logError("Not able to save search history", category: .coredata)
        }
    }
}

#Preview {
    NavigationStack {
        SearchResultView(viewModel: SearchViewModel(viewContext: PersistanceProvider.preview.mainContext))
    }
    .searchable(text: .constant(""))
    .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
    .environmentObject(EnvironmentController.preview)
}
