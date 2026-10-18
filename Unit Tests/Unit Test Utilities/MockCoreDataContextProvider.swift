//
//  MockCoreDataContextProvider.swift
//  D2A
//
//  Created by Shibo Tong on 13/10/2026.
//

@testable import D2A
import CoreData

class MockCoreDataContextProvider: CoreDataContextProviding {
    
    var mainContextCount = 0
    var mainContextResult: NSManagedObjectContext!
    
    var mainContext: NSManagedObjectContext {
        mainContextCount += 1
        return mainContextResult
    }
    
    var backgroundContextResult: NSManagedObjectContext!
    var backgroundContextCount = 0
    var backgroundContextClosure: ((String?) -> NSManagedObjectContext)?
    
    func backgroundContext(name: String?) -> NSManagedObjectContext {
        backgroundContextCount += 1
        if let backgroundContextClosure {
            return backgroundContextClosure(name)
        }
        return backgroundContextResult
    }
}
