//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

import CoreData
import Foundation

extension Ability {

    static func fetch(id: Int, context: NSManagedObjectContext) -> Ability? {
        let fetchAbility: NSFetchRequest<Ability> = Ability.fetchRequest()
        fetchAbility.predicate = NSPredicate(format: "abilityID == %d", id)
        let results = try? context.fetch(fetchAbility)
        return results?.first
    }
    
    static func fetchByName(name: String, context: NSManagedObjectContext) -> Ability? {
        let request = Ability.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            logError("Fetch abilities in \(name) failed: \(error)", category: .coredata)
            return nil
        }
    }

    static func fetchByNames(names: [String], context: NSManagedObjectContext) -> [Ability] {
        let request = Ability.fetchRequest()
        request.predicate = NSPredicate(format: "name IN %@", names)
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            logError("Fetch abilities in \(names) failed: \(error)", category: .coredata)
            return []
        }
    }
}

@objcMembers
public class AbilityAttribute: NSObject, NSSecureCoding {

    public static var supportsSecureCoding: Bool = true

    public var key: String
    public var header: String
    public var value: String
    public var generated: Bool?

    init?(attribute: ODAbility.Attribute) {
        guard let key = attribute.key, let header = attribute.header,
            let value = attribute.value?.transformString()
        else {
            logWarn(
                "Failed to initialize AbilityAttribute with attribute: \(attribute)",
                category: .opendotaConstant)
            return nil
        }
        self.key = key
        self.header = header
        self.value = value
        self.generated = attribute.generated
        super.init()
    }

    init(key: String, header: String, value: String, generated: Bool?) {
        self.key = key
        self.header = header
        self.value = value
        self.generated = generated
        super.init()
    }

    public func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(header, forKey: "header")
        coder.encode(value, forKey: "value")
        coder.encode(generated, forKey: "generated")
    }

    required public init?(coder: NSCoder) {
        guard let key = coder.decodeObject(of: NSString.self, forKey: "key") as? String,
            let header = coder.decodeObject(of: NSString.self, forKey: "header") as? String,
            let value = coder.decodeObject(of: NSString.self, forKey: "value") as? String
        else {
            logError("Failed to decode AbilityAttribute", category: .coredata)
            return nil
        }
        self.key = key
        self.header = header
        self.value = value
        self.generated = coder.decodeObject(of: NSNumber.self, forKey: "generated") as? Bool
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let attribute = object as? AbilityAttribute else {
            return false
        }
        return self == attribute
    }
    
    static func ==(lhs: AbilityAttribute, rhs: AbilityAttribute) -> Bool {
        return lhs.key == rhs.key
        && lhs.header == rhs.header
        && lhs.value == rhs.value
        && lhs.generated == rhs.generated
    }
}
