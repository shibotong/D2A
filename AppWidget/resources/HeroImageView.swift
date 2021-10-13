//
//  HeroImageView.swift
//  App
//
//  Created by Shibo Tong on 13/10/21.
//

import Foundation
import SwiftUI

struct HeroImageView: View {
    var localizedName: String
    
    var body: some View {
        Image(searchHeroImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func searchHeroImage() -> String {
        let filename = "\(localizedName)_icon"
        return filename
    }
    
}
