//
//  HeroIconImageView.swift
//  App
//
//  Created by Shibo Tong on 14/8/21.
//

import SwiftUI
import UIKit

struct HeroIconImageView: View {
    @ObservedObject var vm: HeroIconImageViewModel
    
    init(heroID: Int) {
        self.vm = HeroIconImageViewModel(heroID: heroID)
    }
    
    var body: some View {
        Image(uiImage: vm.icon)
            .resizable()
            .scaledToFit()
    }
    
//    static func == (lhs: HeroIconImageView, rhs: HeroIconImageView) -> Bool {
//        lhs.vm.id == rhs.vm.id
//    }
}

struct HeroIconImageView_Previews: PreviewProvider {
    static var previews: some View {
        HeroIconImageView(heroID: 1)
    }
}

class HeroIconImageViewModel: ObservableObject {
    @Published var icon: UIImage = UIImage(systemName: "person.fill")!
//    var id: Int
    init(heroID: Int) {
//        self.id = heroID
        self.loadHeroIcon(id: heroID)
    }
    
    func loadHeroIcon(id: Int) {
        let hero = HeroDatabase.shared.fetchHeroWithID(id: id)
        guard let hero = hero else {
            return
        }
        OpenDotaController.loadItemImg(url: hero.img) { data in
            guard let img = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.icon = img
            }
        }

    }
}
