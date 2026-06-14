//
//  IntentHandlerTests.swift
//  D2A
//
//  Created by Shibo Tong on 31/5/2026.
//

@testable import D2A
import CoreData
import Testing

class IntentHandlerTests {
    
    let handler: IntentHandler
    let context: NSManagedObjectContext
    let intent: DynamicUserSelectionIntent
    
    init() {
        context = PersistenceProvider.shared.mainContext
        handler = IntentHandler(viewContext: context)
        intent = DynamicUserSelectionIntent()
    }
    
    deinit {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserProfile")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try! context.execute(deleteRequest)
    }
    
    @Test
    func testHasRegisterAndFavorite() async throws {
        let register = createProfile(personaname: "register", isFavorite: true, isRegister: true)
        let favoriteUser1 = createProfile(personaname: "favourite - 1", isFavorite: true)
        let favoriteUser2 = createProfile(personaname: "favourite - 2", isFavorite: true)
        let collection = try await handler.provideProfileOptionsCollection(for: intent)
        #expect(collection.sections.count == 2)
        
        let registeredSection = try #require(collection.sections.first)
        #expect(registeredSection.items.count == 1)
        #expect(registeredSection.title == "Registered")
        let registeredProfile = try #require(registeredSection.items.first)
        #expect(registeredProfile.identifier == register.id)
        #expect(registeredProfile.displayString == register.personaname)
        #expect(registeredProfile.subtitleString == register.id)
        
        let favoriteSection = try #require(collection.sections.last)
        #expect(favoriteSection.title == "Favorite Players")
        #expect(favoriteSection.items.count == 2)
        
        let favoriteProfile1 = try #require(favoriteSection.items.first)
        #expect(favoriteProfile1.identifier == favoriteUser1.id)
        #expect(favoriteProfile1.displayString == favoriteUser1.personaname)
        #expect(favoriteProfile1.subtitleString == favoriteUser1.id)
        
        let favoriteProfile2 = try #require(favoriteSection.items.last)
        #expect(favoriteProfile2.identifier == favoriteUser2.id)
        #expect(favoriteProfile2.displayString == favoriteUser2.personaname)
        #expect(favoriteProfile2.subtitleString == favoriteUser2.id)
    }
    
    @Test
    func testHasRegisterOnly() async throws {
        createProfile(personaname: "register", isFavorite: true, isRegister: true)
        let collection = try await handler.provideProfileOptionsCollection(for: intent)
        #expect(collection.sections.count == 1)
        
        let registeredSection = try #require(collection.sections.first)
        #expect(registeredSection.items.count == 1)
        #expect(registeredSection.title == "Registered")
    }
    
    @Test
    func testHasFavoriteOnly() async throws {
        createProfile(personaname: "favorite", isFavorite: true)
        let collection = try await handler.provideProfileOptionsCollection(for: intent)
        #expect(collection.sections.count == 1)
        
        let favoriteSection = try #require(collection.sections.first)
        #expect(favoriteSection.title == "Favorite Players")
        #expect(favoriteSection.items.count == 1)
    }
    
    @discardableResult
    func createProfile(personaname: String,
                       id: String = UUID().uuidString,
                       isFavorite: Bool = false,
                       isRegister: Bool = false) -> UserProfile {
        let userProfile = UserProfile(context: context)
        userProfile.id = id
        userProfile.favourite = isFavorite
        userProfile.register = isRegister
        userProfile.personaname = personaname
        userProfile.avatarfull = "https://www.opendota.com"
        try! context.save()
        return userProfile
    }
}
