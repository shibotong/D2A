//
//  MatchView+TeamIcon.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import SwiftUI

extension MatchView {
    struct TeamIcon: View {
        
        @EnvironmentObject var environment: EnvironmentController
        
        @State var image: UIImage?
        
        let isRadiant: Bool
        let teamID: String?
        
        private var imageURL: String? {
            guard let teamID else {
                return nil
            }
            return "https://cdn.stratz.com/images/dota2/teams/\(teamID).png"
        }
        
        var body: some View {
            imageView
                .resizable()
                .scaledToFit()
                .task {
                    guard let teamID, let imageURL else {
                        return
                    }
                    await environment.refreshImage(type: .teamIcon, id: teamID, url: imageURL) { image in
                        self.image = image
                    }
                }
        }
        
        var imageView: Image {
            if let image {
                Image(uiImage: image)
            } else {
                Image("icon_\(isRadiant ? "radiant" : "dire")")
            }
        }
    }
}


#Preview {
    MatchView.TeamIcon(isRadiant: false, teamID: nil)
        .environmentObject(EnvironmentController.preview)
}
