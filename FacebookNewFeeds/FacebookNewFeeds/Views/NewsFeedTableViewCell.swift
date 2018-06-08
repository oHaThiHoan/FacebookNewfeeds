//
//  NewsFeedTableViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let imageAttachCollectionViewCellNibName = "ImageAttachCollectionViewCell"
    public static let imageAttachCollectionViewCellIdentifier = "ImageAttachCollectionViewCell"
    public static let heightCollectionView = 300
    public static let heightFeedContent = 50
    public static let visibleModePublic = "public"
    public static let visibleModeFriends = "friends"
}

protocol  NewsFeedTableViewCellDelegate: class {
    func tapToAvatar()
}

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: PhotoView!
    @IBOutlet weak var heightImageAttachCollectionView: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var createAtDateLabel: UILabel!
    @IBOutlet weak var visibleModeImageView: UIImageView!
    @IBOutlet weak var reactionCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var feedContentTextView: UITextView!
    @IBOutlet weak var feedContentHeightConstraint: NSLayoutConstraint!
    weak var delegate: NewsFeedTableViewCellDelegate?
    var numberImageAttach = 0
    var feedModel = FeedModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        feedContentTextView.textContainer.lineBreakMode = .byTruncatingTail
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    @objc func tapToAvatar() {
        guard let delegate = delegate else {
            return
        }
        delegate.tapToAvatar()
    }
    
    public func setContent(feedModel: FeedModel) {
        self.feedModel = feedModel
        if let avatarUrl = feedModel.avatarURL {
            avatarImageView.setImageFromStringURL(stringURL: avatarUrl)
        }
        fullNameLabel.text = feedModel.fullName
        if feedModel.visibleMode == Constants.visibleModePublic {
            visibleModeImageView.image = UIImage(named: "ic-public")
        } else if feedModel.visibleMode == Constants.visibleModeFriends {
            visibleModeImageView.image = UIImage(named: "ic-friends")
        }
        createAtDateLabel.text = feedModel.createAt
        if feedModel.feedContent == "" {
            feedContentHeightConstraint.constant = 0
        } else {
            feedContentHeightConstraint.constant = CGFloat(Constants.heightFeedContent)
        }
        feedContentTextView.text = feedModel.feedContent
        reactionCountLabel.text = feedModel.reactionCount.formatUsingAbbrevation()
        commentCountLabel.text = feedModel.commentCount.formatUsingAbbrevation() + " Comments"
        shareCountLabel.text = feedModel.sharingCount.formatUsingAbbrevation() + " Shares"
        guard let feedImages = feedModel.feedImages else {
            return
        }
        if feedImages.count == 0 {
            heightImageAttachCollectionView.constant = 0
        } else {
            heightImageAttachCollectionView.constant = CGFloat(Constants.heightCollectionView)
        }
        photoView.addImageToStackView(images: feedImages)
    }

}
