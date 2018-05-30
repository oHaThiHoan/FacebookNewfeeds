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

    public func setRestOfImageAttach(number: Int) {
        restOfImageAttachLabel.isHidden = false
        restOfImageAttachLabel.text = "+" + String(number)
    }

}
