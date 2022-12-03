//
//  PermanentBuff.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation

class PermanentBuff: NSObject, NSSecureCoding {
    
    static let supportsSecureCoding: Bool = true
    
    let buffID: Int
    let stack: Int
    
    init(_ permanentBuff: PermanentBuffCodable) {
        self.buffID = permanentBuff.buffID
        self.stack = permanentBuff.stack
    }
    
    enum CodingKeys: String {
        case buffID
        case stack
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(buffID, forKey: CodingKeys.buffID.rawValue)
        coder.encode(stack, forKey: CodingKeys.stack.rawValue)
    }
    
    required init?(coder: NSCoder) {
        guard let buffID = coder.decodeObject(of: NSNumber.self, forKey: CodingKeys.buffID.rawValue) as? Int,
              let stack = coder.decodeObject(of: NSNumber.self, forKey: CodingKeys.stack.rawValue) as? Int else {
            return nil
        }
        self.buffID = buffID
        self.stack = stack
    }
}
