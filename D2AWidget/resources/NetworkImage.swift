//
//  HeroIconImage.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 18/9/21.
//
import Foundation
import SwiftUI

struct NetworkImage: View {
    let urlString: String
    let userID: String
    let image: UIImage?

    let imageType: GameImageType
    let isRadiant: Bool
    
    private let imageProvider: ImageProviding

    private var emptyImage: String {
        switch imageType {
        case .item:
            return "empty_item"
        case .avatar:
            return "profile"
        case .ability:
            return "ability_slot"
        case .teamIcon:
            return "icon_\(isRadiant ? "radiant" : "dire")"
        case .league:
            return "league_template"
        case .hero:
            return "hero"
        }
    }

    init(profile: UserProfile,
         imageProvider: ImageProviding = ImageProvider.shared) {
        userID = profile.id!
        urlString = profile.avatarfull!
        imageType = .avatar
        isRadiant = true
        self.imageProvider = imageProvider
        image = imageProvider.localImage(type: .avatar, id: userID, fileExtension: .jpg)
    }

    init(userID: String, urlString: String, image: UIImage, imageProvider: ImageProviding = ImageProvider.shared) {
        self.userID = userID
        self.urlString = urlString
        imageType = .avatar
        isRadiant = true
        self.imageProvider = imageProvider
        self.image = image
    }

    init(teamID: String, isRadiant: Bool, imageProvider: ImageProviding = ImageProvider.shared) {
        self.urlString = "https://cdn.stratz.com/images/dota2/teams/\(teamID).png"
        self.userID = teamID
        self.isRadiant = isRadiant
        imageType = .teamIcon
        self.imageProvider = imageProvider
        print(teamID)
        if !teamID.isEmpty {
            image = imageProvider.localImage(type: .teamIcon, id: teamID, fileExtension: .png)
        } else {
            image = nil
        }
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(emptyImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
