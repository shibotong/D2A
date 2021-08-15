//
//  ItemViewModel.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import Foundation
import UIKit

class ItemViewModel: ObservableObject {
    @Published var itemImage = UIImage(named: "empty_item")!
    
    private var item: Item?
    
    init(id: Int) {
        self.item = HeroDatabase.shared.fetchItem(id: id)
        guard let _ = self.item else {
            return
        }
        self.fetchItemIcon()
    }
    
    private func fetchItemIcon() {
        guard let item = self.item else{
            return
        }
        OpenDotaController.loadItemImg(url: item.img) { data in
            guard let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.itemImage = image
            }
        }
    }
}
