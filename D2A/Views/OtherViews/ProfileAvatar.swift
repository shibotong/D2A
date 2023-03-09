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
            if let cacheImage = await fetchImage(userID: userID) {
                await setImage(uiImage: cacheImage)
            }
            
            guard let imageURL, let newImage = await loadImage(urlString: imageURL) else {
                return
            }
            ImageCache.saveImage(newImage, type: .avatar, id: userID)
            profile?.lastUpdate = Date()
            try? viewContext.save()
            await setImage(uiImage: newImage)
        }
    }
    
    private func fetchImage(userID: String) async -> UIImage? {
        let cacheImage = ImageCache.readImage(type: .avatar, id: userID)
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
    
//    private func fetchImage() async {
//        guard let userid = profile.id else {
//            return
//        }
//        let cacheImage = ImageCache.readImage(type: .avatar, id: userid)
//        Dispatch.DispatchQueue.main.async {
//            image = cacheImage
//        }
//        guard cacheImage == nil || profile.lastUpdate?.startOfDay != Date().startOfDay else {
//            return
//        }
//        guard let newImage = await loadImage() else {
//            return
//        }
//        ImageCache.saveImage(newImage, type: .avatar, id: userid)
//        profile.lastUpdate = Date()
//        try? viewContext.save()
//        DispatchQueue.main.async {
//            image = newImage
//        }
//    }
//
//    private func loadImage() async -> UIImage? {
//        guard let urlString = profile.avatarfull,
//              let url = URL(string: urlString),
//              let (newImageData, _) = try? await URLSession.shared.data(from: url),
//              let newImage = UIImage(data: newImageData) else {
//            return nil
//        }
//        return newImage
//    }
}
