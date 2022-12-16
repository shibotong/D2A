//
//  ProfileAvatar.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import SwiftUI

struct ProfileAvartar: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var image: UIImage?
    
    let profile: UserProfile
    
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    
    init(profile: UserProfile, sideLength: CGFloat, cornerRadius: CGFloat) {
        self.profile = profile
        self.sideLength = sideLength
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: sideLength, height: sideLength)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else {
                ProgressView()
                    .frame(width: sideLength, height: sideLength)
            }
        }
        .task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        guard let userid = profile.id else {
            return
        }
        let cacheImage = ImageCache.readImage(type: .avatar, id: userid)
        Dispatch.DispatchQueue.main.async {
            image = cacheImage
        }
        if cacheImage == nil || profile.lastUpdate?.startOfDay != Date().startOfDay {
            guard let newImage = await loadImage() else {
                return
            }
            ImageCache.saveImage(newImage, type: .avatar, id: userid)
            profile.lastUpdate = Date()
            try? viewContext.save()
            DispatchQueue.main.async {
                image = newImage
            }
        }
    }
    
    private func loadImage() async -> UIImage? {
        guard let urlString = profile.avatarfull,
              let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}