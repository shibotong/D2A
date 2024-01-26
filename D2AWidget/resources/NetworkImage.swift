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
    
    let imageType: ImageCacheType
    let isRadiant: Bool
    
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
        }
    }
    
    init(profile: UserProfile) {
        userID = profile.id!
        urlString = profile.avatarfull!
        imageType = .avatar
        isRadiant = true
        image = ImageCache.readImage(type: .avatar, id: userID)
    }
    
    init(userID: String, urlString: String, image: UIImage) {
        self.userID = userID
        self.urlString = urlString
        imageType = .avatar
        isRadiant = true
        self.image = image
    }
    
    init(teamID: String, isRadiant: Bool) {
        self.urlString = "https://cdn.stratz.com/images/dota2/teams/\(teamID).png"
        self.userID = teamID
        self.isRadiant = isRadiant
        imageType = .teamIcon
        print(teamID)
        if !teamID.isEmpty {
            image = ImageCache.readImage(type: .teamIcon, id: teamID, fileExtension: "png")
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
