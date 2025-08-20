//
//  SearchHistoryView.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftUI

struct SearchHistoryView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.searchTime)])
    var searchHistories: FetchedResults<SearchHistory>
    
    var body: some View {
        ForEach(searchHistories) { history in
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
        }
    }
}

#Preview {
    SearchHistoryView()
        .environment(\.managedObjectContext, PersistanceProvider.preview.mainContext)
        .environmentObject(EnvironmentController.preview)
}
