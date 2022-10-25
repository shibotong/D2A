//
//  LiveDraftView.swift
//  D2A
//
//  Created by Shibo Tong on 24/10/2022.
//

import SwiftUI

struct LiveDraftView: View {
    
    var drafts: [BanPick]
    
    var body: some View {
        HStack(spacing: 5) {
            buildHeroes(isRadiant: true, isPicked: false)
            buildHeroes(isRadiant: true, isPicked: true)
            Spacer()
            buildHeroes(isRadiant: false, isPicked: true)
            buildHeroes(isRadiant: false, isPicked: false)
        }
        .frame(height: 250)
    }
    
    @ViewBuilder private func buildHeroes(isRadiant: Bool, isPicked: Bool) -> some View {
        let heroes = drafts.filter { $0.isRadiant == isRadiant && $0.isPick == isPicked }
        VStack {
                ForEach(heroes, id:\.heroID) { hero in
                    if isPicked {
                        HeroImageView(heroID: hero.heroID, type: .full)
                    } else {
                        HeroImageView(heroID: hero.heroID, type: .icon)
                            .grayscale(1)
                    }
                }
        }
    }
}

struct LiveDraftView_Previews: PreviewProvider {
    @State static var drafts: [BanPick] = BanPick.preview
    static var previews: some View {
        LiveDraftView(drafts: drafts)
    }
}
