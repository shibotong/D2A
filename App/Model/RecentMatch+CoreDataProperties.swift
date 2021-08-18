//
//  RecentMatch+CoreDataProperties.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData


extension RecentMatch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentMatch> {
        return NSFetchRequest<RecentMatch>(entityName: "RecentMatch")
    }

    @NSManaged public var id: Int64
    @NSManaged public var playerId: Int64
    @NSManaged public var duration: Int16
    @NSManaged public var mode: Int16
    @NSManaged public var radiantWin: Bool
    @NSManaged public var slot: Int16
    @NSManaged public var heroID: Int16
    @NSManaged public var kills: Int16
    @NSManaged public var deaths: Int16
    @NSManaged public var assists: Int16
    @NSManaged public var lobbyType: Int16
    @NSManaged public var startTime: Int64

}

extension RecentMatch : Identifiable {

}
