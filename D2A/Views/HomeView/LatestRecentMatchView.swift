//
//  LatestRecentMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 15/1/2023.
//

import SwiftUI
import CoreData

struct LatestRecentMatchView: View {
    
    @FetchRequest private var matches: FetchedResults<RecentMatch>
    @FetchRequest private var latestMatch: FetchedResults<RecentMatch>
    
    private var userID: String
    
    init(userid: String) {
        userID = userid
        let request = NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
        request.fetchLimit = 25
        request.fetchBatchSize = 1
        let availableModes = [1, 2, 3, 4, 5, 12, 13, 14, 16, 17, 22]
        let modeMultiplePredicates = availableModes.map { return NSPredicate(format: "mode = %d", $0) }
        let modePredicate = NSCompoundPredicate(type: .or, subpredicates: modeMultiplePredicates)
        let userPredicate = NSPredicate(format: "playerId = %@", userid)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [userPredicate, modePredicate])
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)]
        _matches = FetchRequest(fetchRequest: request)
        
        let latestRequest = NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
        latestRequest.fetchLimit = 1
        latestRequest.fetchBatchSize = 1
        latestRequest.predicate = userPredicate
        latestRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)]
        _latestMatch = FetchRequest(fetchRequest: latestRequest)
    }
    
    var body: some View {
        ZStack {
            if matches.count != 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        let fetchedMatches = matches.count >= 25 ? Array(matches[0..<25]) : Array(matches)
                        ForEach(fetchedMatches) { match in
                            RecentMatchWinLossView(heroID: Int(match.heroID), playerWin: match.playerWin)
                        }
                    }
                    .padding(.leading)
                }
            } else {
                ProgressView()
            }
        }
        .frame(height: 70)
        .task {
            await OpenDotaProvider.shared.loadRecentMatch(userid: userID)
        }
    }
}

struct LatestRecentMatchView_Previews: PreviewProvider {
    static var previews: some View {
        LatestRecentMatchView(userid: "preview")
            .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
            .previewLayout(.fixed(width: 300, height: 60))
    }
}
