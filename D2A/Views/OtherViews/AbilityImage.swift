//
//  AbilityImage.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import SwiftUI
import UIKit

struct AbilityImage: View {

    @ObservedObject var viewModel: AbilityImageViewModel
    
    init(name: String?, urlString: String?) {
        viewModel = .init(name: name, urlString: urlString)
    }

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("ability_slot")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.label)
            }
        }
    }
}

#Preview {
    AbilityImage(name: "Acid Spray", urlString: "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/abilities/alchemist_acid_spray.png")
}
