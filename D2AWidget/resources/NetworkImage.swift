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
    let contentMode: ContentMode
    
    init(urlString: String, contentMode: ContentMode = .fit) {
        self.urlString = urlString
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let url = URL(string: urlString), let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            }
            else {
                Image("profile")
                    .resizable()
            }
        }
    }
    
}
