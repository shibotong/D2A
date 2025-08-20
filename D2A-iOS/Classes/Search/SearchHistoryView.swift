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
                    Divider()
                }
            }
            .padding(.horizontal)
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
