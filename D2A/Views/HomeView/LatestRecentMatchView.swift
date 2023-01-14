//
//  LatestRecentMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 15/1/2023.
//

import SwiftUI
import CoreData

struct LatestRecentMatchView: View {
    
    @FetchRequest private var match: FetchedResults<RecentMatch>
    
    init(userid: String) {
        let request = NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
        request.fetchLimit = 1
        request.fetchBatchSize = 1
        request.predicate = NSPredicate(format: "playerId = %@", userid)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RecentMatch.startTime, ascending: false)]
        _match = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ZStack {
            if let match = match.first {
                MatchListRowView(match: match)
                    .border(.bar)
            } else {
                Text("No Recent Match")
            }
        }
    }
}

struct LatestRecentMatchView_Previews: PreviewProvider {
    static var previews: some View {
        LatestRecentMatchView(userid: "preview")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
