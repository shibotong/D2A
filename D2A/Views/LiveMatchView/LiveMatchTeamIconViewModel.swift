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
    
    var isRadiant: Bool
    
    var team: Team?
    
    init(teamID: String?, isRadiant: Bool) {
        self.isRadiant = isRadiant
        guard let teamID else {
            return
        }
        team = Team.fetchTeam(id: teamID)
        if team == nil {
            team = try? Team.createTeam(id: teamID)
        }
        self.image = team?.teamIcon
        Task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        guard let team, let teamID = team.teamID, !teamID.isEmpty else {
            return
        }
        
        if image != nil && !team.shouldUpdate {
            return
        }
        
        print("team should update \(teamID)")
        
        guard let newImage = await loadImage(urlString: team.teamIconURL) else {
            return
        }
        ImageCache.saveImage(newImage, type: .teamIcon, id: teamID, fileExtension: "png")
        // update team refresh date
        _ = try? Team.createTeam(id: teamID)
        await setImage(newImage)
    }
    
    private func loadImage(urlString: String) async -> UIImage? {
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
