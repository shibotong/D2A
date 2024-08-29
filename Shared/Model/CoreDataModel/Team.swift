//
//  Team.swift
//  D2A
//
//  Created by Shibo Tong on 28/2/2024.
//

import Foundation
import CoreData
import UIKit

extension Team {
    
    var shouldUpdate: Bool {
        guard let lastUpdate else {
            return true
        }
        return !lastUpdate.isToday
    }
    
    var teamIconURL: String {
        guard let teamID else {
            return ""
        }
        return "https://cdn.stratz.com/images/dota2/teams/\(teamID).png"
    }
    
    var teamIcon: UIImage? {
        guard let teamID else {
            return nil
        }
        return ImageCache.readImage(type: .teamIcon, id: teamID, fileExtension: "png")
    }
    
    static func createTeam(id: String,
                           viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> Team {
        
        let team = fetchTeam(id: id) ?? Team(context: viewContext)
        team.teamID = id
        team.lastUpdate = Date()
        
        try viewContext.save()
        return team
    }
    
    static func fetchTeam(id: String,
                          viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Team? {
        let fetchTeam: NSFetchRequest<Team> = Team.fetchRequest()
        fetchTeam.predicate = NSPredicate(format: "teamID == %f", id)
        
        let results = try? viewContext.fetch(fetchTeam)
        return results?.first
    }
}
