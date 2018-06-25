//
//  PhotoView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/25/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let photoViewNibName = "PhotoView"
}

class PhotoView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var restLabel: UILabel!
    var actionOnPhoto: (() -> Void)?

    func configure(url: String, text: String) {
        imageView.setImageFromStringURL(stringURL: url)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        restLabel.text = text
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnPhoto)))
    }

    @objc func tapOnPhoto() {
        if let action = actionOnPhoto {
            action()
        }
    }

}
