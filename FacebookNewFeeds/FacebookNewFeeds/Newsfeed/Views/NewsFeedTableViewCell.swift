//
//  NewsFeedTableViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
import Reactions

private struct Constants {
    public static let imageAttachCollectionViewCellNibName = "ImageAttachCollectionViewCell"
    public static let imageAttachCollectionViewCellIdentifier = "ImageAttachCollectionViewCell"
    public static let heightCollectionView = 300
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
    var numberImageAttach = 0
    var feedModel = FeedModel()
    var indexPath: IndexPath?
    @IBOutlet weak var reactionButton: ReactionButton! {
        didSet {
            reactionButton.reactionSelector = ReactionSelector()
            reactionButton.config = ReactionButtonConfig(block: { (config) in
                config.iconMarging = 8
                config.spacing = 4
                config.font = UIFont(name: "HelveticaNeue", size: 12)
                config.neutralTintColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
                config.alignment = .left
            })
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    @objc func tapToAvatar() {
        delegate?.tapToAvatar(feedModel: feedModel)
    }

    public func setContent(feedModel: FeedModel, indexPath: IndexPath) {
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
        if feedImages.count == 0 {
            heightImageAttachCollectionView.constant = 0
        } else {
            heightImageAttachCollectionView.constant = CGFloat(Constants.heightCollectionView)
        }
        photoView.addImageToStackView(images: feedImages)
        self.indexPath = indexPath
        guard let reaction = feedModel.reaction else {
            reactionButton.isSelected = false
            reactionButton.reaction = Reaction.facebook.like
            return
        }
        reactionButton.isSelected = true
        reactionButton.reaction = reaction
    }

    @IBAction func commentAction(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickCommentButton(indexPath: indexPath)
    }

    @IBAction func reactionAction(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        if feedModel.reaction == nil {
            feedModel.reactionCount += 1
        }
        feedModel.reaction = reactionButton.reaction
        delegate?.clickLikeButton(indexPath: indexPath, feedModel: feedModel)
    }

    @IBAction func reactTouchUpInsideAction(_ sender: Any) {
        if reactionButton.isSelected {
            feedModel.reaction = reactionButton.reaction
            feedModel.reactionCount += 1
        } else {
            feedModel.reaction = nil
            feedModel.reactionCount -= 1
            reactionButton.reaction = Reaction.facebook.like
        }
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickLikeButton(indexPath: indexPath, feedModel: feedModel)
    }

}
