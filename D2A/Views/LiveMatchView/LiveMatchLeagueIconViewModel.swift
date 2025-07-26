//
//  LiveMatchLeagueIconViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 28/6/2023.
//

import Foundation
import UIKit

class LiveMatchLeagueIconViewModel: ObservableObject {
    @Published var image: UIImage?

    var leagueID: Int
    var urlString: String = ""
    
    
    private let imageProvider: GameImageProviding
    private let imageType: GameImageType = .league

    init(leagueID: Int,
         imageProvider: GameImageProviding = GameImageProvider.shared) {
        self.leagueID = leagueID
        self.urlString = "https://cdn.stratz.com/images/dota2/leagues/\(leagueID).png"
        self.imageProvider = imageProvider
        self.image = imageProvider.localImage(type: imageType, id: leagueID.description, fileExtension: .png)
        Task {
            await fetchImage()
        }
    }

    private func fetchImage() async {
        if image != nil {
            return
        }
        guard let newImage = await loadImage() else {
            return
        }
        try? imageProvider.saveImage(image: newImage, type: imageType, id: leagueID.description, fileExtension: .png)
        await setImage(newImage)
    }

    private func loadImage() async -> UIImage? {
        guard let url = URL(string: urlString),
            let (newImageData, _) = try? await URLSession.shared.data(from: url),
            let newImage = UIImage(data: newImageData)
        else {
            return nil
        }

        return newImage
    }

    @MainActor
    private func setImage(_ image: UIImage) {
        self.image = image
    }

}
