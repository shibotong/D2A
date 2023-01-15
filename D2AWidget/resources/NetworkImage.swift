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
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    var body: some View {
        Group {
            if let url = URL(string: urlString), let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            }
            else {
                Image("profile")
                    .resizable()
            }
        }
    }
}
