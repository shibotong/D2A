//
//  SharingLInk.swift
//  App
//
//  Created by Shibo Tong on 25/7/2022.
//

import Foundation
import LinkPresentation

class SharingLink: NSObject, UIActivityItemSource {

    var title: String
    var text: String
    var image: UIImage?

    var metadata: LPLinkMetadata

    init(title: String, link: String, image: UIImage?) {
        self.title = title
        self.text = link
        self.image = image

        metadata = LPLinkMetadata()
        metadata.title = title
        if let image = image {
            metadata.iconProvider = NSItemProvider(object: image)
        }
        metadata.originalURL = URL(fileURLWithPath: text)
        metadata.url = metadata.originalURL

        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController)
        -> Any
    {
        return text
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return text
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController)
        -> LPLinkMetadata?
    {
        return metadata
    }
}
