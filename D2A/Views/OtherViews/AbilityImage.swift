//
//  AbilityImage.swift
//  D2A
//
//  Created by Shibo Tong on 26/2/2023.
//

import SwiftUI
import UIKit
import Logging

struct AbilityImage: View {
    
    @ObservedObject var viewModel: ViewModel
    private let logger: Logger?
    
    init(name: String, imageProvider: ImageProviding = ImageProvider.shared, logger: Logger? = D2ALogger.ui) {
        viewModel = .init(name: name, imageProvider: imageProvider)
        self.logger = logger
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
                        await fetchImage()
                    }
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    
    private func fetchImage() async {
        do {
            try await viewModel.fetchImage()
        } catch {
            logger?.error("\(error.localizedDescription)")
        }
    }
}

#if DEBUG
#Preview {
    AbilityImage(name: "antimage_blink", imageProvider: MockImageProvider())
}
#endif
