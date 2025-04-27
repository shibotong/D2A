//
//  ProfileAvatar.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import SwiftUI

struct ProfileAvatar: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var image: UIImage?
    
    private let profile: UserProfile?
    
    private let cornerRadius: CGFloat
    private let userID: String
    private let imageURL: String?
    
    init(profile: UserProfile, cornerRadius: CGFloat) {
        self.profile = profile
        userID = profile.id?.description ?? "0"
        imageURL = profile.avatarfull
        self.cornerRadius = cornerRadius
    }
    
    init(userID: String, imageURL: String, cornerRadius: CGFloat, profile: UserProfile? = nil) {
        self.userID = userID
        self.imageURL = imageURL
        self.cornerRadius = cornerRadius
        self.profile = profile
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius).stroke().foregroundColor(Color(uiColor: .systemGray6))
                    }
            } else {
                ProgressView()
            }
        }
        .task {
            let cacheImage = fetchImage(userID: userID)
            
            if let cacheImage {
                await setImage(uiImage: cacheImage)
            }
        
            if profile == nil || cacheImage == nil || profile!.shouldUpdate {
                guard let imageURL, let newImage = await loadImage(urlString: imageURL) else {
                    return
                }
                ImageCache.shared.saveImage(newImage, type: .avatar, id: userID)
                await setImage(uiImage: newImage)
            }
        }
    }
    
    private func fetchImage(userID: String) -> UIImage? {
        let cacheImage = ImageCache.shared.readImage(type: .avatar, id: userID)
        return cacheImage
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
    private func setImage(uiImage: UIImage) async {
        image = uiImage
    }
}
