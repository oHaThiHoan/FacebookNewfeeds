//
//  ImageAttachCollectionViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class ImageAttachCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var restOfImageAttachLabel: UILabel!
    @IBOutlet weak var attachImageView: UIImageView!

    public func setContent(imageUrl: String) {
        attachImageView.setImageFromStringURL(stringURL: imageUrl)
    }

    public func setRestOfImageAttach(number: Int) {
        if number == 0 {
            restOfImageAttachLabel.isHidden = true
        } else {
            restOfImageAttachLabel.isHidden = false
            restOfImageAttachLabel.text = "+" + String(number)
        }
    }

}
