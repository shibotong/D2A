//
//  IntentHandler.swift
//  AppWidgetIntentHandler
//
//  Created by Shibo Tong on 18/9/21.
//

import Intents
import UIKit

class IntentHandler: INExtension, DynamicUserSelectionIntentHandling {
    
    func provideProfileOptionsCollection(for intent: DynamicUserSelectionIntent, with completion: @escaping (INObjectCollection<Profile>?, Error?) -> Void) {
        print("configuring profile")
        let registeredID = DotaEnvironment.shared.registerdID
        let profiles: [Profile] = DotaEnvironment.shared.userIDs.map { id in
            let profile = UserProfile.fetch(id: id)
            return Profile(identifier: id, display: "\(profile?.name ?? profile?.personaname ?? "Unknown")", subtitle: "\(id)", image: nil)
        }
        
        guard let registeredProfile = UserProfile.fetch(id: registeredID) else {
            let collection = INObjectCollection(items: profiles)
            completion(collection, nil)
            return
        }
        let registerProfile = Profile(identifier: registeredProfile.id, display: "\(registeredProfile.name ?? registeredProfile.personaname ?? "")", subtitle: "\(registeredProfile.id ?? "")", image: nil)
        let registerSection = INObjectSection(title: "Registered", items: [registerProfile])
        let profileSection = INObjectSection(title: "Favorite Players", items: profiles)
        let collection = INObjectCollection(sections: [registerSection, profileSection])
        completion(collection, nil)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
