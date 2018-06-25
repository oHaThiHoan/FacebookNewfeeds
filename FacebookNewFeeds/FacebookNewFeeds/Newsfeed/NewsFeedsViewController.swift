//
//  NewsFeedsViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/29/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let photoShowViewControllerIdentifier = "PhotoShowViewController"
    public static let heightLoadMoreCell: CGFloat = 44
    public static let profileViewControllerIdentifier = "ProfileViewController"
    public static let numberNewsFeedShow = 10
    public static let commentViewController = "CommentViewController"
    public static let pageStoriesViewControllerIdentifier = "PageStoriesViewController"
    public static let collectionViewTopInset: CGFloat = 0
    public static let collectionViewLeftInset: CGFloat = 5
    public static let collectionViewBottomInset: CGFloat = 0
    public static let collectionViewRightInset: CGFloat = 5
    public static let estimateHeightRow: CGFloat = 500.0
}

class NewsFeedsViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var newsFeedTableView: UITableView!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.update(textFieldPlaceHolder: "Search",
                             textFieldBackground: CommonConstants.colorSearchBarBackground,
                             textFieldColor: CommonConstants.colorTextFieldPlaceHolder)
        }
    }
    var feedsArray: [FeedModel] = []
    var storiesArray: [StoryModel] = []
    var feedsTempArray: [FeedModel] = []
    let interactor = Interactor()
    @IBOutlet weak var cameraImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraImageView.isUserInteractionEnabled = true
        friendsCollectionView.dataSource = self
        friendsCollectionView.delegate = self
        friendsCollectionView.contentInset = UIEdgeInsets(top: Constants.collectionViewTopInset,
            left: Constants.collectionViewLeftInset, bottom: Constants.collectionViewBottomInset,
            right: Constants.collectionViewRightInset)
        friendsCollectionView.register(nibName: FriendCollectionViewCell.self)
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        scrollView.delegate = self
        newsFeedTableView.register(nibName: NewsFeedTableViewCell.self)
        newsFeedTableView.register(nibName: LoadMoreTableViewCell.self)
        getData()
    }

    func getData() {
        let spinner = UIViewController.displaySpinner(onView: friendsCollectionView)
        QueryService.get(url: Url.newsFeedUrl, success: { (response) in
            UIViewController.removeSpinner(spinner: spinner)
            guard let responseFeedData = response["feeds"] as? [[String: Any]] else {
                return
            }
            for feed in responseFeedData {
                let feedModel = FeedModel.init(response: feed)
                self.feedsArray.append(feedModel)
                if self.feedsTempArray.count < Constants.numberNewsFeedShow {
                    self.feedsTempArray.append(feedModel)
                }
            }
            DispatchQueue.main.async {
                self.newsFeedTableView.reloadData()
            }
            guard let responseStoryData = response["stories"] as? [[String: Any]] else {
                return
            }
            for story in responseStoryData {
                let storyModel = StoryModel.init(response: story)
                self.storiesArray.append(storyModel)
            }
            DispatchQueue.main.async {
                self.friendsCollectionView.reloadData()
            }
        }, failure: { (_) in
            UIViewController.removeSpinner(spinner: spinner)
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = scrollView.contentOffset.y < 0 ? false: true
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            let beginElement = feedsTempArray.count
            var endElement = 0
            if feedsArray.count > feedsTempArray.count + Constants.numberNewsFeedShow {
                endElement = feedsTempArray.count + Constants.numberNewsFeedShow - 1
            } else {
                endElement = feedsArray.count - 1
            }
            if beginElement <= endElement {
                for index in beginElement...endElement {
                    feedsTempArray.append(feedsArray[index])
                }
                DispatchQueue.main.async {
                    self.newsFeedTableView.reloadData()
                }
            }
        }
    }

}

extension NewsFeedsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storiesArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(FriendCollectionViewCell.self, indexPath)
        cell.setContent(storyModel: storiesArray[indexPath.row])
        return cell
    }

}

extension NewsFeedsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendCollectionViewCell else {
            return
        }
        cell.clickImage { [weak self] in
            guard let context = self, let pageStoriesViewController = context.storyboard?.instantiateViewController(
                withIdentifier: Constants.pageStoriesViewControllerIdentifier) as? PageStoriesViewController else {
                    return
            }
            pageStoriesViewController.beginPageIndex = indexPath.row
            pageStoriesViewController.storiesArray = context.storiesArray
            context.present(pageStoriesViewController, animated: true, completion: nil)
        }
    }

}

extension NewsFeedsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return feedsTempArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NewsFeedTableViewCell.self)
        let feedModel = feedsTempArray[indexPath.row]
        cell.setContent(feedModel: feedModel, indexPath: indexPath, view: view)
        cell.delegate = self
        return cell
    }

}

extension NewsFeedsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightOfTableView.constant = newsFeedTableView.contentSize.height
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end display: \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return feedsTempArray.count == feedsArray.count ? UIView(frame: .zero) :
            tableView.dequeueReusableCell(LoadMoreTableViewCell.self)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.heightLoadMoreCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.estimateHeightRow
    }

}

extension NewsFeedsViewController: NewsFeedTableViewCellDelegate {

    func clickLikeButton(indexPath: IndexPath, completed: (Int) -> Void) {
        let feedModel = feedsTempArray[indexPath.row]
        guard let cell = newsFeedTableView.cellForRow(at: indexPath) as? NewsFeedTableViewCell else {
            return
        }
        if cell.reactionButton.isSelected {
            if feedModel.reaction == ReactionType.none {
                feedModel.reactionCount += 1
            }
        } else {
            feedModel.reactionCount -= 1
        }
        feedModel.reaction = cell.reactionButton.reactionType
        completed(feedModel.reactionCount)
    }

    func clickCommentButton(indexPath: IndexPath) {
        guard let commentViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.commentViewController) as? CommentViewController else {
                return
        }
        commentViewController.transitioningDelegate = self
        commentViewController.interactor = interactor
        commentViewController.feedModel = feedsTempArray[indexPath.row]
        commentViewController.indexPath = indexPath
        commentViewController.delegate = self
        present(commentViewController, animated: true, completion: nil)
    }

    func tapToAvatar(indexPath: IndexPath) {
        guard let profileViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.profileViewControllerIdentifier) as? ProfileViewController else {
                return
        }
        let profileModel = ProfileModel()
        let feedModel = feedsTempArray[indexPath.row]
        profileModel.avatarUrl = feedModel.avatarURL
        profileModel.fullName = feedModel.fullName
        profileViewController.profileModel = profileModel
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    func tapOnPhoto(indexPath: IndexPath) {
        guard let photoShowViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.photoShowViewControllerIdentifier) as? PhotoShowViewController else {
                return
        }
        photoShowViewController.feedModel = feedsTempArray[indexPath.row]
        navigationController?.pushViewController(photoShowViewController, animated: true)
    }

}

extension NewsFeedsViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
                                           -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }

}

extension NewsFeedsViewController: CommentControllerDelegate {

    func dismiss(feedModel: FeedModel, indexPath: IndexPath) {
        feedsTempArray[indexPath.row] = feedModel
        if let cell = newsFeedTableView.cellForRow(at: indexPath) as? NewsFeedTableViewCell {
            cell.updateReactionButton(feedModel: feedModel)
        }
    }

}
