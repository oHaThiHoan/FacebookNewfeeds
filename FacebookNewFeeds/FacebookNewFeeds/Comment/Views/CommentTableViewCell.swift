//
//  CommentTableViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/11/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let cornerCommentView: CGFloat = 10
}
class CommentTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var commentModel: CommentModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        commentView.layer.cornerRadius = Constants.cornerCommentView
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }

    func setContent(commentModel: CommentModel) {
        self.commentModel = commentModel
        nameLabel.text = commentModel.fullName
        contentLabel.text = commentModel.comment
        guard let avatarUrl = commentModel.avatarUrl else {
            return
        }
        avatarImageView.setImageFromStringURL(stringURL: avatarUrl)
    }

}
