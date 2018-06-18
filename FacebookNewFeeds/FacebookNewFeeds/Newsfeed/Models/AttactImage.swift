//
//  AttactImage.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/6/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class AttactImage: NSObject {
    var width = 0.0
    var height = 0.0
    var ratio = 0.0
    var image: UIImage?
    var imageView = UIImageView()
    var url: String?

    init(url: String) {
        super.init()
        self.url = url
        imageView.setImageFromStringURL(stringURL: url)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        guard let imageFromUrl = imageView.image else {
            return
        }
        image = imageFromUrl
        width = Double(imageFromUrl.size.width)
        height = Double(imageFromUrl.size.height)
        ratio = width / height
    }
}
