//
//  IntentHandler.swift
//  AppWidgetIntentHandler
//
//  Created by Shibo Tong on 18/9/21.
//

import Intents

class IntentHandler: INExtension, SelectUserIntentHandling {
    func providePlayerOptionsCollection(for intent: SelectUserIntent, with completion: @escaping (INObjectCollection<UserProfile>?, Error?) -> Void) {
        let profiles: [UserProfile] = DotaEnvironment.shared.userIDs.map { id in
            let profile = WCDBController.shared.fetchUserProfile(userid: id)!
            return profile
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
