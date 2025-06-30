//
//  AttributeImage.swift
//  D2A
//
//  Created by Shibo Tong on 22/4/2023.
//

import SwiftUI

struct AttributeImage: View {

    let attribute: HeroAttribute?

    var body: some View {
        if let attribute {
            Image("attribute_\(attribute.rawValue)")
                .resizable()
        } else {
            EmptyView()
        }
    }
}

struct AttributeImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(HeroAttribute.allCases, id: \.self) { attribute in
                AttributeImage(attribute: attribute)
                    .previewLayout(.fixed(width: 20, height: 20))
            }
        }
    }
}
