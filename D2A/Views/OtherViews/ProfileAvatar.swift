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
    
    let profile: UserProfile
    
    let cornerRadius: CGFloat
    
    init(profile: UserProfile, cornerRadius: CGFloat) {
        self.profile = profile
        self.cornerRadius = cornerRadius
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
        guard cacheImage == nil || profile.lastUpdate?.startOfDay != Date().startOfDay else {
            return
        }
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
