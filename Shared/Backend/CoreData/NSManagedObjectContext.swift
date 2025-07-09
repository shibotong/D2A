//
//  NSManagedObjectContext.swift
//  D2A
//
//  Created by Shibo Tong on 9/7/2025.
//

import CoreData

//extension NSManagedObjectContext {
//    func calculateDaysSinceLastMatch(userID: String) -> Double? {
//        guard let latestMatch = RecentMatch.fetch(userID: userID, count: 1, viewContext: self).first else {
//            return nil
//        }
//        
//        var days: Double?
//        // here should be timeIntervalSinceNow
//        if let lastMatchStartTime = latestMatch.startTime?.timeIntervalSinceNow {
//            let oneDay: Double = 60 * 60 * 24
//
//            // Decrease 1 sec to avoid adding repeated match
//            days = -(lastMatchStartTime + 1) / oneDay
//        }
//        
//        return days
//    }
//}
