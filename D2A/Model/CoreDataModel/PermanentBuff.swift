//
//  PermanentBuff.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation

extension PermanentBuff {
    static func create(_ permanentBuff: PermanentBuffCodable) -> PermanentBuff {
        let viewContext = PersistenceController.shared.container.viewContext
        let buff = PermanentBuff(context: viewContext)
        buff.id = UUID()
        buff.buffID = Int16(permanentBuff.buffID)
        buff.stack = Int32(permanentBuff.stack)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return buff
    }
}
