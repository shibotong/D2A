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
    
    var body: some View {
        ZStack {
            EmptyView()
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
        .frame(width: viewModel.sideLength, height: viewModel.sideLength)
        .cornerRadius(viewModel.cornerRadius)
    }
}
