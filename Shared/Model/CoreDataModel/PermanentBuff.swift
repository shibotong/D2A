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
        print(Thread.isMainThread)
        buff.update(permanentBuff)
        return buff
    }
    
    func update(_ permanentBuff: PermanentBuffCodable) {
        self.buffID = Int16(permanentBuff.buffID)
        self.stack = Int32(permanentBuff.stack)
    }
}
