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
    public static let heightCollectionView = 150
    public static let heightFeedContent = 50
    public static let visibleModePublic = "public"
    public static let visibleModeFriends = "friends"
}

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
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
    var numberImageAttach = 0
    var feedModel = FeedModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib.init(nibName: Constants.imageAttachCollectionViewCellNibName, bundle: nil),
                                     forCellWithReuseIdentifier: Constants.imageAttachCollectionViewCellIdentifier)
        feedContentTextView.textContainer.lineBreakMode = .byTruncatingTail
        selectionStyle = .none
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
        if let feedImages = feedModel.feedImages {
            numberImageAttach = feedImages.count
        }
        if numberImageAttach == 0 {
            heightImageAttachCollectionView.constant = 0
        } else {
            heightImageAttachCollectionView.constant = CGFloat(Constants.heightCollectionView)
            imageCollectionView.reloadData()
        }
    }

}

extension NewsFeedTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let feedImages = feedModel.feedImages else {
            return 0
        }
        return feedImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            Constants.imageAttachCollectionViewCellIdentifier, for: indexPath) as? ImageAttachCollectionViewCell,
            let feedImages = feedModel.feedImages else {
            return UICollectionViewCell()
        }
        let attachImageURL = feedImages[indexPath.row]
        cell.setContent(imageUrl: attachImageURL)
        if indexPath.row == 3 && numberImageAttach > 4 {
            let restOfImageAttach = numberImageAttach - 4
            cell.setRestOfImageAttach(number: restOfImageAttach)
        } else {
            cell.setRestOfImageAttach(number: 0)
        }
        return cell
    }

}

extension NewsFeedTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        if  numberImageAttach == 0 {
            width = 0
            height = 0
        } else if numberImageAttach <= 2 {
            width = UIScreen.main.bounds.width / CGFloat(numberImageAttach) - CGFloat(5 * (numberImageAttach + 1))
            height = CGFloat(Constants.heightCollectionView)
        } else {
            width = UIScreen.main.bounds.width / CGFloat(2) - 15
            height = CGFloat(Constants.heightCollectionView / 2)
        }
        return CGSize(width: width, height: height)
    }

}
