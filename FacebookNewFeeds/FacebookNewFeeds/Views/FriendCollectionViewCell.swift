//
//  FriendCollectionViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }

}
