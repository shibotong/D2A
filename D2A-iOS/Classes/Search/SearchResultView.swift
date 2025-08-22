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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.searchTime)])
    var searchHistories: FetchedResults<SearchHistory>
    
    @State private var clearSearchDialogIsPresented = false
    
    var body: some View {
        if isSearching && !searchHistories.isEmpty {
            searchHistoryPage
        } else {
            emptySearchPage
        }
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
}

#Preview {
    NavigationStack {
        SearchResultView()
    }
    .searchable(text: .constant(""))
    .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
    .environmentObject(EnvironmentController.preview)
}
