//
//  NewsFeedsViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/29/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let friendCollectionViewCellNibName = "FriendCollectionViewCell"
    public static let friendCollectionViewCellIdentifier = "FriendCollectionViewCell"
    public static let newsFeedTableViewCellNibName = "NewsFeedTableViewCell"
    public static let newsFeedTableViewCellIdentifier = "NewsFeedTableViewCell"
    public static let loadMoreTableViewCellNibName = "LoadMoreTableViewCell"
    public static let loadMoreTableViewCellIdentifier = "LoadMoreTableViewCell"
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
    @IBOutlet weak var searchTextField: UISearchTextField! {
        didSet {
            searchTextField.attribute = AttributeTextField(block: { (attribute) in
                attribute.placeHolderText = "Search"
                attribute.placeHolderColor = CommonConstants.colorTextFieldPlaceHolder
            })
        }
    }
    var feedsArray: [FeedModel] = []
    var storiesArray: [StoryModel] = []
    var feedsTempArray: [FeedModel] = []
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollectionView.dataSource = self
        friendsCollectionView.delegate = self
        friendsCollectionView.contentInset = UIEdgeInsets(top: Constants.collectionViewTopInset,
            left: Constants.collectionViewLeftInset, bottom: Constants.collectionViewBottomInset,
            right: Constants.collectionViewRightInset)
        friendsCollectionView.register(UINib(nibName: Constants.friendCollectionViewCellNibName, bundle: nil),
            forCellWithReuseIdentifier: Constants.friendCollectionViewCellIdentifier)
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        scrollView.delegate = self
        newsFeedTableView.register(UINib(nibName: Constants.newsFeedTableViewCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.newsFeedTableViewCellIdentifier)
        newsFeedTableView.register(UINib(nibName: Constants.loadMoreTableViewCellNibName, bundle: nil),
            forHeaderFooterViewReuseIdentifier: Constants.loadMoreTableViewCellIdentifier)
        let spinner = UIViewController.displaySpinner(onView: friendsCollectionView)
        QueryService.get(url: Url.newsFeedUrl, success: { (response) in
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
            UIViewController.removeSpinner(spinner: spinner)
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.friendCollectionViewCellIdentifier,
            for: indexPath) as? FriendCollectionViewCell else {
                return UICollectionViewCell()
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsFeedTableViewCellIdentifier,
            for: indexPath) as? NewsFeedTableViewCell else {
                return UITableViewCell()
        }
        let feedModel = feedsTempArray[indexPath.row]
        cell.setContent(feedModel: feedModel, indexPath: indexPath)
        cell.delegate = self
        return cell
    }

}

extension NewsFeedsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightOfTableView.constant = newsFeedTableView.contentSize.height
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return feedsTempArray.count == feedsArray.count ? UIView(frame: .zero) :
            tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.loadMoreTableViewCellIdentifier)
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

    func clickLikeButton(indexPath: IndexPath, feedModel: FeedModel) {
        feedsTempArray[indexPath.row] = feedModel
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

    func tapToAvatar(feedModel: FeedModel) {
        guard let profileViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.profileViewControllerIdentifier) as? ProfileViewController else {
                return
        }
        let profileModel = ProfileModel()
        profileModel.avatarUrl = feedModel.avatarURL
        profileModel.fullName = feedModel.fullName
        profileViewController.profileModel = profileModel
        navigationController?.pushViewController(profileViewController, animated: true)
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
        newsFeedTableView.reloadRows(at: [indexPath], with: .none)
    }

}
