//
//  LiveMatchListView.swift
//  D2A
//
//  Created by Shibo Tong on 14/6/2023.
//

import SwiftUI
import StratzAPI

struct LiveMatchListView: View {
    
    @StateObject private var viewModel: LiveMatchListViewModel = .init()
    
    var body: some View {
        List {
            ForEach(viewModel.matches, id: \.self) { id in
                NavigationLink(destination: LiveMatchView(viewModel: LiveMatchViewModel(matchID: id.description))) {
                    Text(id.description)
                }
            }
            Button {
                viewModel.loadMore()
            } label: {
                Text("Load more")
            }
        }
        .refreshable {
            viewModel.fetchMatches(existItems: 0)
        }
    }
}

class LiveMatchListViewModel: ObservableObject {
    @Published var matches: [Int] = []
    
    init() {
        self.fetchMatches(existItems: 0)
    }
    
    func loadMore() {
        let currentItems = matches.count
        fetchMatches(existItems: currentItems)
    }
    
    func fetchMatches(existItems: Int) {
        print("start query")
        let fetchQuery = MatchLiveRequestType(
            gameStates: [
                .case(.teamShowcase),
                .case(.gameInProgress),
                .case(.heroSelection),
                .case(.preGame),
                .case(.strategyTime)
            ],
            skip: GraphQLNullable<Int>(integerLiteral: existItems)
        )
        Network.shared.apollo.fetch(query: LiveMatchListQuery(request: .init(fetchQuery))) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                guard let matches = graphQLResult.data?.live?.matches, let self else {
                    return
                }
                let newMatches = matches.map { id in
                    return id?.matchId ?? 0
                }
                if existItems == 0 {
                    self.matches = []
                }
                for match in newMatches where !self.matches.contains(match) {
                    self.matches.append(match)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct LiveMatchListView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchListView()
    }
}
