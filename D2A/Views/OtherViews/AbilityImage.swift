//
//  AbilityImage.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import SwiftUI
import UIKit

struct AbilityImage: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(name: String, imageProvider: ImageProviding = ImageProvider.shared) {
        viewModel = .init(name: name, imageProvider: imageProvider)
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("ability_slot")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.label)
                    .task {
                        await viewModel.fetchImage()
                    }
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

#if DEBUG
#Preview {
    AbilityImage(name: "antimage_blink", imageProvider: MockImageProvider())
}
#endif
