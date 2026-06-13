//
//  IntentHandler.swift
//  AppWidgetIntentHandler
//
//  Created by Shibo Tong on 18/9/21.
//

import Intents
import CoreData

class IntentHandler: INExtension, DynamicUserSelectionIntentHandling {
    
    private let context: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceProvider.shared.mainContext) {
        self.context = viewContext
    }
    
    func provideProfileOptionsCollection(for intent: DynamicUserSelectionIntent) async throws -> INObjectCollection<Profile> {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        
        let results = try context.fetch(fetchRequest)

        let profiles: [Profile] = results.filter({ !$0.register }).map { userProfile in
            return Profile(identifier: userProfile.id,
                           display: "\(userProfile.name ?? userProfile.personaname ?? "Unknown")",
                           subtitle: "\(userProfile.id?.description ?? "")",
                           image: nil)
        }
        
        guard let registerUserProfile = results.first(where: { $0.register }) else {
            let collection = INObjectCollection(items: profiles)
            return collection
        }
        
        let registerProfile = Profile(identifier: registerUserProfile.id,
                                      display: "\(registerUserProfile.name ?? registerUserProfile.personaname ?? "")",
                                      subtitle: "\(registerUserProfile.id ?? "")",
                                      image: nil)
        let registerSection = INObjectSection(title: "Registered", items: [registerProfile])
        let profileSection = INObjectSection(title: "Favorite Players", items: profiles)
        let collection = INObjectCollection(sections: [registerSection, profileSection])
        return collection
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
