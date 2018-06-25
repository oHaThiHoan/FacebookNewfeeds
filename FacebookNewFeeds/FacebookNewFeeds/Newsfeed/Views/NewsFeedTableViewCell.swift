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

    func tapToAvatar(indexPath: IndexPath)
    func clickLikeButton(indexPath: IndexPath, completed: (Int) -> Void)
    func clickCommentButton(indexPath: IndexPath)
    func tapOnPhoto(indexPath: IndexPath)

}

class NewsFeedTableViewCell: UITableViewCell, ReusableView {
    @IBOutlet weak var photoView: ListAttachView!
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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var shareView: UIView!
    var numberImageAttach = 0
    var indexPath: IndexPath?
    var constraintHeaderView: NSLayoutConstraint?
    var constraintCommentView: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        reactionButton.delegate = self
        constraintHeaderView = NSLayoutConstraint(item: photoView, attribute: .top, relatedBy: .equal,
            toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        constraintHeaderView?.isActive = false
        constraintCommentView = NSLayoutConstraint(item: commentView, attribute: .trailing, relatedBy: .equal,
            toItem: footerView, attribute: .trailing, multiplier: 1, constant: 0)
        constraintCommentView?.isActive = false
    }

    @objc func tapToAvatar() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.tapToAvatar(indexPath: indexPath)
    }

    func setContent(feedModel: FeedModel, indexPath: IndexPath, view: UIView? = nil) {
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
        photoView.actionTapOnPhoto = { [weak self] in
            if let indexPath = self?.indexPath {
                self?.delegate?.tapOnPhoto(indexPath: indexPath)
            }
        }
        self.indexPath = indexPath
        reactionButton.parentView = view
        if let reaction = feedModel.reaction, reaction != ReactionType.none {
            reactionButton.isSelected = true
            reactionButton.reactionType = reaction
        } else {
            reactionButton.isSelected = false
        }
        if let avatarUrl = feedModel.avatarURL {
            avatarImageView.setImageFromStringURL(stringURL: avatarUrl)
        }
        fullNameLabel.text = feedModel.fullName
        if feedModel.visibleMode == Constants.visibleModePublic {
            visibleModeImageView.image = UIImage(named: "ic-public")
            shareView.isHidden = false
            constraintCommentView?.isActive = false
        } else if feedModel.visibleMode == Constants.visibleModeFriends {
            visibleModeImageView.image = UIImage(named: "ic-friends")
            shareView.isHidden = true
            constraintCommentView?.isActive = true
        }
        createAtDateLabel.text = feedModel.createAt
        feedContentLabel.text = feedModel.feedContent
    }

    func setContent(attachImage: AttachModel, indexPath: IndexPath, view: UIView? = nil) {
        headerView.isHidden = true
        constraintHeaderView?.isActive = true
        reactionCountLabel.text = attachImage.reactionCount > 0 ? attachImage.reactionCount.formatUsingAbbrevation(): ""
        commentCountLabel.text = attachImage.commentCount > 0 ?
            attachImage.commentCount.formatUsingAbbrevation() + " Comments" : ""
        shareCountLabel.text = attachImage.sharingCount > 0 ?
            attachImage.sharingCount.formatUsingAbbrevation() + " Shares" : ""
        heightImageAttachCollectionView.constant = Constants.heightCollectionView
        photoView.addImageToStackView(images: [attachImage])
        self.indexPath = indexPath
        reactionButton.parentView = view
        if let reaction = attachImage.reaction, reaction != ReactionType.none {
            reactionButton.isSelected = true
            reactionButton.reactionType = reaction
        } else {
            reactionButton.isSelected = false
        }
    }

    override func prepareForReuse() {
        headerView.isHidden = false
        constraintHeaderView?.isActive = false
        avatarImageView.image = nil
    }

    @IBAction func commentAction(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickCommentButton(indexPath: indexPath)
    }

    func updateReactionButton(feedModel: FeedModel) {
        guard let reaction = feedModel.reaction, reaction != ReactionType.none else {
            reactionButton.isSelected = false
            reactionButton.reactionType = ReactionType.none
            return
        }
        reactionButton.isSelected = true
        reactionButton.reactionType = reaction
    }

}

extension NewsFeedTableViewCell: ReactionButtonDelegate {

    func changeValue() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.clickLikeButton(indexPath: indexPath, completed: { [weak self] (reactionCount) in
            self?.reactionCountLabel.text = reactionCount.formatUsingAbbrevation()
        })
    }

}
