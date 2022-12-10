//
//  ProfileAvatar.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import SwiftUI

struct ProfileAvartar: View {
    
    @State var image: UIImage?
    
    let urlString: String
    let userid: Int
    
    let sideLength: CGFloat
    let cornerRadius: CGFloat
    
    init(profile: UserProfile, sideLength: CGFloat, cornerRadius: CGFloat) {
        self.urlString = profile.avatarfull ?? ""
        self.userid = Int(profile.id ?? "0") ?? 0
        self.sideLength = sideLength
        self.cornerRadius = cornerRadius
    }
    
    init(userid: Int, urlString: String, sideLength: CGFloat, cornerRadius: CGFloat) {
        self.urlString = urlString
        self.userid = userid
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
        let cache = ImageCache.shared
        guard let url = URL(string: urlString) else {
            return
        }
        let image = try? await cache.fetchImage(type: .avatar, id: userid, url: url)
        self.image = image
    }
    
    
}
