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
    
    private let imageSize: CGFloat = 40
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.hasResults {
            suggestions
        } else {
            emptySearchPage
        }
    }
    
    private var suggestions: some View {
        List {
            if let match = viewModel.searchedMatch {
                NavigationLink(destination: MatchView(matchid: match.matchID.description)) {
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
                NavigationLink(value: hero) {
                    HStack {
                        HeroImageViewV2(hero: hero, type: .icon)
                            .frame(width: imageSize)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        buildTitle(title: hero.heroNameLocalized, subTitle: "Hero")
                    }
                }
            }
            ForEach(viewModel.localProfiles) { profile in
                NavigationLink(value: profile.id?.description ?? "") {
                    ProfileView(profile: profile)
                }
            }
            ForEach(viewModel.remoteProfiles) { profile in
                NavigationLink(value: profile.accountID.description) {
                    ProfileView(userID: profile.accountID.description, personaname: profile.personaname, avatarfull: profile.avatarFull
                    )
                }
            }
        }
        .listStyle(.plain)
        .foregroundColor(.label)
        .navigationDestination(for: Hero.self) { hero in
            HeroDetailViewV2(hero: hero)
        }
        .navigationDestination(for: String.self) { userID in
            PlayerProfileView(userid: userID)
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
    
    @ViewBuilder
    private func buildTitle(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(subTitle)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryLabel)
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
