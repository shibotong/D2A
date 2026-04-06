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
    
    init(viewModel: AbilityImageViewModel) {
        self.viewModel = viewModel
    }
    
    init(name: String) {
        viewModel = .init(name: name)
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
    AbilityImage(name: "alchemist_acid_spray")
}
