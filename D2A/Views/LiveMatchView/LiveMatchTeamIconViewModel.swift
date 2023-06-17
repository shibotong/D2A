//
//  LiveMatchTeamIconViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 17/6/2023.
//

import Foundation
import UIKit

class LiveMatchTeamIconViewModel: ObservableObject {
    @Published var image: UIImage?
    
    var teamID: String
    var urlString: String
    var isRadiant: Bool
    
    init(teamID: String, isRadiant: Bool) {
        self.teamID = teamID
        self.urlString = "https://cdn.stratz.com/images/dota2/teams/\(teamID).png"
        self.isRadiant = isRadiant
        self.image = ImageCache.readImage(type: .teamIcon, id: teamID, fileExtension: "png")
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
        ImageCache.saveImage(newImage, type: .teamIcon, id: teamID, fileExtension: "png")
        await setImage(newImage)
    }
    
    private func loadImage() async -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        
        return newImage
    }
    
    @MainActor
    private func setImage(_ image: UIImage) {
        self.image = image
    }
    
}
