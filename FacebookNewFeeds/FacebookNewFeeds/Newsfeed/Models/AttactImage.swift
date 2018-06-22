//
//  AttactImage.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/6/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

public struct FileType {
    public static let video = "video"
    public static let image = "image"
}

class AttactImage: NSObject {
    var width = 0.0
    var height = 0.0
    var ratio = 0.0
    var image: UIImage?
    var itemView = UIView()
    var url: String?

    init(attachModel: AttachImageModel) {
        super.init()
        self.url = attachModel.url
        let fileType = attachModel.type
        if FileType.image == fileType {
            let itemView = UIImageView()
            self.itemView = itemView
            itemView.setImageFromStringURL(stringURL: attachModel.url)
            itemView.contentMode = .scaleAspectFill
            itemView.layer.masksToBounds = true
        } else if FileType.video == fileType,
            let itemView = UINib(nibName: "VideoView", bundle: nil).instantiate(withOwner: nil, options: nil).first
            as? VideoView {
            self.itemView = itemView
            itemView.configure(url: attachModel.url)
        }
    }

}
