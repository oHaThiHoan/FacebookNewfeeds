//
//  LoadMoreCommentTableViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/12/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

protocol LoadMoreCommentDelegate: class {
    func loadMoreAction(view: LoadMoreCommentTableViewCell)
}

class LoadMoreCommentTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var loadMoreLabel: UILabel!
    weak var delegate: LoadMoreCommentDelegate?
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        loadMoreImageView.isHidden = false
        loadMoreIndicator.isHidden = true
    }

    @IBAction func loadMoreAction(_ sender: Any) {
        delegate?.loadMoreAction(view: self)
    }

    func startLoading() {
        loadMoreLabel.text = "Loading comments..."
        loadMoreImageView.isHidden = true
        loadMoreIndicator.isHidden = false
        loadMoreIndicator.startAnimating()
    }

    public func stopLoading() {
        loadMoreLabel.text = "Load previous comments"
        loadMoreImageView.isHidden = false
        loadMoreIndicator.isHidden = true
        loadMoreIndicator.stopAnimating()
    }

}
