//
//  SampleData.swift
//  D2A
//
//  Created by Shibo Tong on 30/11/2025.
//

import Foundation
import CoreData

struct SampleData {
    static var context: NSManagedObjectContext {
        let context = PersistenceController(inMemory: true)
        return context.container.viewContext
    }
    
    static var heroes: [Hero] {
        let context = Self.context
        guard let data = loadFile(filename: "heroes"),
              let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }
        
        var heroes: [Hero] = []
        for (_, heroData) in jsonData {
            guard let heroObject = heroData as? [String: Any] else {
                continue
            }
            let hero = Hero(context: context)
            hero.map(json: heroObject)
            heroes.append(hero)
        }
        try? context.save()
        return heroes
    }
    
    static private func loadFile(filename: String) -> Data? {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            print("No such file")
            return nil
        }
    }
}
