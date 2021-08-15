//
//  ItemController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 18/7/21.
//

import Foundation

class ItemController {
    private static var itemID: [String: String] = loadItemIDs()!
    private static let items: [String: Any] = loadItems()!
    
    static func fetchItemImg(id: String, onCompletion: @escaping (Data) -> ()) {
        let itemName = itemID[id]!
        let item = items[itemName] as! [String: Any]
        OpenDotaController.loadItemImg(url: item["img"] as! String) { data in
            onCompletion(data)
        }
    }
    
}
