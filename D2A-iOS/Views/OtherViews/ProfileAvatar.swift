//
//  ProfileAvatar.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2022.
//

import SwiftUI

struct ProfileAvatar: View {

    @EnvironmentObject private var environment: EnvironmentController
    @State var image: UIImage?

    private let cornerRadius: CGFloat
    private let userID: String
    private let imageURL: String?

    init(profile: UserProfile, cornerRadius: CGFloat) {
        userID = profile.id?.description ?? "0"
        imageURL = profile.avatarfull
        self.cornerRadius = cornerRadius
    }

    init(userID: String, imageURL: String, cornerRadius: CGFloat) {
        self.userID = userID
        self.imageURL = imageURL
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
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke()
                            .foregroundColor(
                            Color(uiColor: .systemGray6))
                    }
            } else {
                ProgressView()
            }
        }
        .task {
            try? await environment.refreshImage(type: .avatar, id: userID, url: imageURL ?? "") { image in
                self.image = image
            }
        }
    }
}
