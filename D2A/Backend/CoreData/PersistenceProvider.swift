//
//  PersistenceProvider.swift
//  D2A
//
//  Created by Shibo Tong on 2/4/2026.
//

import CoreData

protocol PersistenceProviderProtocol {
    func fetchHero(id: Double, context: NSManagedObjectContext) throws -> Hero?
}

class PersistenceProvider: PersistenceProviderProtocol {
    
    static let shared = PersistenceProvider()
    
    func fetchHero(id: Double, context: NSManagedObjectContext) throws -> Hero? {
        let fetchHero = Hero.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "id == %f", id)
        
        let results = try context.fetch(fetchHero)
        return results.first
    }
}
