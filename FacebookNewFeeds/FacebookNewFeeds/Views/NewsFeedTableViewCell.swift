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
    public static let heightCollectionView = 200
    public static let heightFeedContent = 50
    public static let visibleModePublic = "public"
    public static let visibleModeFriends = "friends"
}

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
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
        guard let feedImages = feedModel.feedImages else {
            return
        }
        if feedImages.count == 0 {
            heightImageAttachCollectionView.constant = 0
        } else {
            heightImageAttachCollectionView.constant = CGFloat(Constants.heightCollectionView)
        }
        addImageToStackView(images: feedImages)
    }

    private func addImageToStackView (images: [String]) {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
        if images.count == 1 {
            addOneImage(image: images[0], toStackView: stackView)
        } else if images.count == 2 {
            for index in 0...1 {
                addOneImage(image: images[index], toStackView: stackView)
            }
        } else if images.count == 3 {
            addThreeImage(images: images, toStackView: stackView)
        } else if images.count >= 4 {
            addFourImage(images: images, toStackView: stackView) { (lastImageView) in
                let restLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width / 4,
                                                      y: lastImageView.frame.height / 2, width: 50, height: 50))
                let restNumber = images.count - 4
                if restNumber > 0 {
                    restLabel.text = "+" + String(restNumber)
                }
                restLabel.textColor = .white
                lastImageView.addSubview(restLabel)
            }
        }
    }

    private func addOneImage(image: String, toStackView: UIStackView) {
        let imageView = UIImageView()
        imageView.setImageFromStringURL(stringURL: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        toStackView.addArrangedSubview(imageView)
    }

    private func addThreeImage(images: [String], toStackView: UIStackView) {
        var attachImageArray: [AttactImage] = []
        var firstImageView = AttactImage(url: images[0])
        var firstImageViewIndex = 0
        for index in 0...2 {
            let attachImage = AttactImage(url: images[index])
            attachImageArray.append(attachImage)
            if attachImage.ratio < firstImageView.ratio {
                firstImageView = attachImage
                firstImageViewIndex = index
            }
        }
        attachImageArray.remove(at: firstImageViewIndex)
        let subStackView = initStackView()
        if firstImageView.ratio > (16 / 9) {
            toStackView.axis = .vertical
            subStackView.axis = .horizontal
        } else {
            subStackView.axis = .vertical
        }
        toStackView.addArrangedSubview(firstImageView.imageView)
        for attachImage in attachImageArray {
            subStackView.addArrangedSubview(attachImage.imageView)
        }
        toStackView.addArrangedSubview(subStackView)
    }

    private func addFourImage(images: [String], toStackView: UIStackView, addMoreText: (UIImageView) -> Void) {
        var attachImageArray: [AttactImage] = []
        var firstImageView = AttactImage(url: images[0])
        var firstImageViewIndex = 0
        for index in 0...3 {
            let attachImage = AttactImage(url: images[index])
            attachImageArray.append(attachImage)
            if attachImage.ratio < firstImageView.ratio {
                firstImageView = attachImage
                firstImageViewIndex = index
            }
        }
        if firstImageView.ratio == 1 {
            let subStackView = initStackView()
            subStackView.axis = .vertical
            for index in 0...1 {
                subStackView.addArrangedSubview(attachImageArray[index].imageView)
            }
            let subStackView1 = initStackView()
            subStackView.axis = .vertical
            subStackView1.addArrangedSubview(attachImageArray[2].imageView)
            let lastImageView = attachImageArray[3].imageView
            addMoreText(lastImageView)
            subStackView1.addArrangedSubview(lastImageView)
            toStackView.addArrangedSubview(subStackView)
            toStackView.addArrangedSubview(subStackView1)
        } else {
            attachImageArray.remove(at: firstImageViewIndex)
            toStackView.addArrangedSubview(firstImageView.imageView)
            let subStackView =  initStackView()
            subStackView.axis = .vertical
            let lastImageView = attachImageArray.remove(at: attachImageArray.count - 1)
            for attachImage in attachImageArray {
                subStackView.addArrangedSubview(attachImage.imageView)
            }
            addMoreText(lastImageView.imageView)
            subStackView.addArrangedSubview(lastImageView.imageView)
            toStackView.addArrangedSubview(subStackView)
        }
    }

    private func initStackView() -> UIStackView {
        let subStackView = UIStackView()
        subStackView.distribution = .fillEqually
        subStackView.spacing = 1
        return subStackView
    }

}
