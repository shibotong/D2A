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
    
    init(profile: UserProfile) {
        userID = profile.id!
        urlString = profile.avatarfull!
        image = ImageCache.readImage(type: .avatar, id: userID)
    }
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else if let url = URL(string: urlString), let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("profile")
                    .resizable()
            }
        }
    }
}
