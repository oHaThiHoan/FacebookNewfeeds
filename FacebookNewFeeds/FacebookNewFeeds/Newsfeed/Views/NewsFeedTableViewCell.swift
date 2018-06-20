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
    public static let heightCollectionView: CGFloat = 300
    public static let heightFeedContent = 50
    public static let visibleModePublic = "public"
    public static let visibleModeFriends = "friends"
    public static let colorFeedReacted: UIColor = .blue
    public static let colorFeedUnReacted: UIColor = .lightGray
}

protocol  NewsFeedTableViewCellDelegate: class {

    func tapToAvatar(feedModel: FeedModel)
    func clickLikeButton(indexPath: IndexPath, feedModel: FeedModel)
    func clickCommentButton(indexPath: IndexPath)

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
    @IBOutlet weak var feedContentLabel: UILabel!
    weak var delegate: NewsFeedTableViewCellDelegate?
    @IBOutlet weak var reactionButton: ReactionButton!
    @IBOutlet weak var shareImageView: UIImageView!
    var numberImageAttach = 0
    var feedModel = FeedModel()
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        reactionButton.delegate = self
    }

    @objc func tapToAvatar() {
        delegate?.tapToAvatar(feedModel: feedModel)
    }

    public func setContent(feedModel: FeedModel, indexPath: IndexPath, view: UIView? = nil) {
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
        feedContentLabel.text = feedModel.feedContent
        reactionCountLabel.text = feedModel.reactionCount > 0 ? feedModel.reactionCount.formatUsingAbbrevation() : ""
        commentCountLabel.text = feedModel.commentCount > 0 ?
            feedModel.commentCount.formatUsingAbbrevation() + " Comments" : ""
        shareCountLabel.text = feedModel.sharingCount > 0 ?
            feedModel.sharingCount.formatUsingAbbrevation() + " Shares" : ""
        guard let feedImages = feedModel.feedImages else {
            return
        }
        heightImageAttachCollectionView.constant = feedImages.count == 0 ? 0 : Constants.heightCollectionView
        photoView.addImageToStackView(images: feedImages)
        self.indexPath = indexPath
        reactionButton.parentView = view
        if let reaction = feedModel.reaction, reaction != ReactionType.none {
            reactionButton.isSelected = true
            reactionButton.reactionType = reaction
        } else {
            reactionButton.isSelected = false
        }
    }

    @IBAction func commentAction(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickCommentButton(indexPath: indexPath)
    }

}

extension NewsFeedTableViewCell: ReactionButtonDelegate {

    func changeValue() {
        if reactionButton.isSelected {
            if feedModel.reaction == ReactionType.none {
                feedModel.reactionCount += 1
            }
        } else {
            feedModel.reactionCount -= 1
        }
        reactionCountLabel.text = feedModel.reactionCount.formatUsingAbbrevation()
        feedModel.reaction = reactionButton.reactionType
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickLikeButton(indexPath: indexPath, feedModel: feedModel)
    }

}
