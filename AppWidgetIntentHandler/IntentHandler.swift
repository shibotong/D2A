//
//  IntentHandler.swift
//  AppWidgetIntentHandler
//
//  Created by Shibo Tong on 18/9/21.
//

import Intents

class IntentHandler: INExtension, DynamicUserSelectionIntentHandling {
    
    func provideProfileOptionsCollection(for intent: DynamicUserSelectionIntent, with completion: @escaping (INObjectCollection<Profile>?, Error?) -> Void) {
        print("configuring profile")
        let profiles: [Profile] = DotaEnvironment.shared.userIDs.map { id in
            let profile = WCDBController.shared.fetchUserProfile(userid: id)
            return Profile(identifier: id, display: "\(profile?.personaname ?? "UnknownName")")
        }
        let collection = INObjectCollection(items: profiles)
        completion(collection, nil)
    }

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
