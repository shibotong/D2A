//
//  SearchHistoryView.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftUI
import CoreData

struct SearchHistoryView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.searchTime)])
    var searchHistories: FetchedResults<SearchHistory>
    
    @State var clearSearchDialogIsPresented = false
    
    var body: some View {
        ScrollView {
            if searchHistories.isEmpty {
                EmptyView()
            } else {
                searchList
            }
        }
        .confirmationDialog(LocalizableStrings.clearSearchTitle, isPresented: $clearSearchDialogIsPresented, titleVisibility: .visible) {
            Button(LocalizableStrings.clearSearchButton, role: .destructive, action: clearSearch)
            Button(LocalizableStrings.cancel, role: .cancel) {
                clearSearchDialogIsPresented = false
            }
        } message: {
            Text(LocalizableStrings.clearSearchDescription)
        }
    }
    
    private var searchList: some View {
        VStack {
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
            Divider()
            ForEach(searchHistories) { history in
                if let hero = history.hero {
                    NavigationLink(destination: HeroDetailViewV2(hero: hero)) {
                        HStack {
                            SearchHeroRowView(hero: hero)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .bold()
                        }
                    }
                }
                if let user = history.player {
                    NavigationLink(destination: PlayerProfileView(userid: user.id ?? "")) {
                        HStack {
                            ProfileView(viewModel: ProfileViewModel(profile: user))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .bold()
                        }
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
                            Spacer()
                            Image(systemName: "chevron.right")
                                .bold()
                        }
                    }
                }
                Divider()
            }
        }
        .padding(.horizontal)
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
    SearchHistoryView()
        .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
        .environmentObject(EnvironmentController.preview)
}
