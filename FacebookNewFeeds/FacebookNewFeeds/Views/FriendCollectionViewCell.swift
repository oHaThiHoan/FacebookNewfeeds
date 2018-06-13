//
//  FriendCollectionViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
private struct Constants {
    public static let borderWidth: CGFloat = 1
    public static let colorBorder: CGColor = UIColor.blue.cgColor
}

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = Constants.borderWidth
        avatarImageView.layer.borderColor = Constants.colorBorder
    }

    public func setContent(storyModel: StoryModel) {
        if let stringURL = storyModel.storyImageUrl {
            avatarImageView.setImageFromStringURL(stringURL: stringURL)
        }
    }

}
