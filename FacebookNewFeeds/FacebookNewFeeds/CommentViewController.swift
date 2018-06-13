//
//  CommentViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/11/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

protocol CommentControllerDelegate: class {
    func dismiss(feedModel: FeedModel, indexPath: IndexPath)
}

private struct Constants {
    public static let cornerRadiusView: CGFloat = 10
    public static let percentDragdismissible: CGFloat = 0.3
    public static let cornerCommentView: CGFloat = 10
    public static let borderWidthCommentView: CGFloat = 1
    public static let colorBorderWidthCommentView: CGColor = UIColor.lightGray.cgColor
    public static let maxHeightOfBottomView: CGFloat = 100
    public static let colorButtonSend: UIColor = .blue
    public static let colorButtonReact: UIColor = .blue
    public static let colorButtonUnReact: UIColor = .lightGray
    public static let commentCellNibName = "CommentTableViewCell"
    public static let commentCellIdentifier = "CommentTableViewCell"
    public static let loadMoreTableViewCellNibName = "LoadMoreCommentTableViewCell"
    public static let loadMoreTableViewCellIdentifier = "LoadMoreCommentTableViewCell"
    public static let urlComment = "https://www.mocky.io/v2/5b1f4c023100006500230769"
    public static let numberCommentShow = 10
    public static let plusHeightOfTextView: CGFloat = 32
}

class CommentViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var heightOfBottomView: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var reactButton: UIButton!
    @IBOutlet weak var reactLabel: UILabel!
    @IBOutlet weak var reactImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentListView: UIView!
    var feedModel = FeedModel()
    var indexPath: IndexPath?
    var interactor: Interactor?
    weak var delegate: CommentControllerDelegate?
    var commentArray: [CommentModel] = []
    var commentTempArray: [CommentModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = Constants.cornerRadiusView
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        commentView.layer.cornerRadius = Constants.cornerCommentView
        commentView.layer.borderWidth = Constants.borderWidthCommentView
        commentView.layer.borderColor = Constants.colorBorderWidthCommentView
        commentTextView.delegate = self
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(UINib(nibName: Constants.commentCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.commentCellIdentifier)
        commentTableView.register(UINib(nibName: Constants.loadMoreTableViewCellNibName, bundle: nil),
                                   forHeaderFooterViewReuseIdentifier: Constants.loadMoreTableViewCellIdentifier)
        if feedModel.isReacted {
            reactImageView.image = reactImageView.image?.transform( withNewColor: Constants.colorButtonReact)
            reactLabel.text = " You and \((feedModel.reactionCount - 1).formatUsingAbbrevation()) others"
        } else {
            reactImageView.image = reactImageView.image?.transform( withNewColor: Constants.colorButtonUnReact)
            reactLabel.text = String (feedModel.reactionCount.formatUsingAbbrevation())
        }
        QueryService.get(view: commentListView, url: Constants.urlComment, showIndicator: true) { (response) in
            guard let responseCommentData = response["comments"] as? [[String: Any]] else {
                return
            }
            for comment in responseCommentData {
                let commentModel = CommentModel(response: comment)
                self.commentArray.append(commentModel)
                if self.commentTempArray.count < Constants.numberCommentShow {
                    self.commentTempArray.append(commentModel)
                }
            }
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
            }
        }
    }

    @IBAction func sendAction(_ sender: Any) {
        let commentModel = CommentModel(avatarUrl: feedModel.avatarURL, fullName: feedModel.fullName,
            comment: commentTextView.text)
        commentArray.insert(commentModel, at: 0)
        commentTempArray.insert(commentModel, at: 0)
        commentTextView.text = ""
        commentTableView.beginUpdates()
        commentTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        commentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        commentTableView.endUpdates()
    }

    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = Constants.percentDragdismissible
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else {
            return
        }
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish(): interactor.cancel()
        default:
            break
        }
    }

    @IBAction func reactAction(_ sender: Any) {
        if feedModel.isReacted {
            reactImageView.image = reactImageView.image?.transform(withNewColor: Constants.colorButtonUnReact)
            feedModel.isReacted = false
            reactLabel.text = String (feedModel.reactionCount.formatUsingAbbrevation())
        } else {
            reactImageView.image = reactImageView.image?.transform(withNewColor: Constants.colorButtonReact)
            feedModel.isReacted = true
            reactLabel.text = " You and \(feedModel.reactionCount.formatUsingAbbrevation()) others"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let indexPath = self.indexPath else {
            return
        }
        delegate?.dismiss(feedModel: feedModel, indexPath: indexPath)
    }

}

extension CommentViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            sendButton.imageView?.image = sendButton.imageView?.image?.transform(
                withNewColor: Constants.colorButtonSend)
        }
        let heightOfTextView = textView.contentSize.height + Constants.plusHeightOfTextView
        if heightOfTextView <= Constants.maxHeightOfBottomView {
            heightOfBottomView.constant = heightOfTextView
        } else {
            heightOfBottomView.constant = Constants.maxHeightOfBottomView
        }
    }

}

extension CommentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentTempArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCellIdentifier,
            for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
        }

        cell.setContent(commentModel: commentTempArray[indexPath.row])
        return cell
    }

}

extension CommentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.loadMoreTableViewCellIdentifier) as? LoadMoreCommentTableViewCell else {
                return UITableViewHeaderFooterView()
        }
        footerView.delegate = self
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if commentArray.count == commentTempArray.count {
            return 0.001
        }
        return 44
    }

}

extension CommentViewController: LoadMoreCommentDelegate {

    func loadMoreAction(view: LoadMoreCommentTableViewCell) {
        let beginElement = commentTempArray.count
        var endElement = commentTempArray.count + Constants.numberCommentShow
        if endElement >  commentArray.count {
            endElement = commentArray.count
        }
        endElement -= 1
        if endElement >= beginElement {
            for index in beginElement...endElement {
                commentTempArray.append(commentArray[index])
            }
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
                view.stopLoading()
            }
        }
    }

}
