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
    public static let durationClick = 0.2
    public static let imageScale: CGFloat = 0.8
    public static let imageMaxScale: CGFloat = 1
}

class FriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        borderView.layer.cornerRadius = borderView.frame.width / 2
        borderView.clipsToBounds = true
        borderView.layer.borderWidth = Constants.borderWidth
        borderView.layer.borderColor = Constants.colorBorder

    }

    public func setContent(storyModel: StoryModel) {
        if let stringURL = storyModel.storyImageUrl {
            avatarImageView.setImageFromStringURL(stringURL: stringURL)
        }
    }

    func clickImage(completed: @escaping () -> Void) {
        UIView.animate(withDuration: Constants.durationClick, animations: {() -> Void in
            self.avatarImageView?.transform = CGAffineTransform(scaleX: Constants.imageScale, y: Constants.imageScale)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: Constants.durationClick, animations: {() -> Void in
                self.avatarImageView?.transform = CGAffineTransform(scaleX: Constants.imageMaxScale,
                    y: Constants.imageMaxScale)
                completed()
            })

        })
    }

}
