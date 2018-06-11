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
    public static let url = "https://www.mocky.io/v2/5b19e5ce3300006800fb122e"
    public static let profileViewControllerIdentifier = "ProfileViewController"
    public static let colorSearchBarBackground = "#2E4780"
    public static let numberNewsFeedShow = 10
    public static let commentViewController = "CommentViewController"
}

class NewsFeedsViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var newsFeedTableView: UITableView!
    var feedsArray: [FeedModel] = []
    var storyArray: [StoryModel] = []
    var feedsTempArray: [FeedModel] = []
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarItems()
        friendsCollectionView.dataSource = self
        friendsCollectionView.register(UINib(nibName: Constants.friendCollectionViewCellNibName, bundle: nil),
                                       forCellWithReuseIdentifier: Constants.friendCollectionViewCellIdentifier)
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        newsFeedTableView.register(UINib(nibName: Constants.newsFeedTableViewCellNibName, bundle: nil),
                                   forCellReuseIdentifier: Constants.newsFeedTableViewCellIdentifier)
        newsFeedTableView.register(UINib(nibName: Constants.loadMoreTableViewCellNibName, bundle: nil),
                                   forHeaderFooterViewReuseIdentifier: Constants.loadMoreTableViewCellIdentifier)
        QueryService.get(context: self, url: Constants.url) { (response) in
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
                self.storyArray.append(storyModel)
            }
            DispatchQueue.main.async {
                self.friendsCollectionView.reloadData()
            }
        }
    }

    private func setUpNavigationBarItems() {
        let searchBar = UISearchBar(frame: .zero, textFieldPlaceHolder: "Search",
            textFieldBackground: UIColor(hexString: Constants.colorSearchBarBackground), textFieldColor: .white)
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "camera"),
            style: .done, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"),
            style: .done, target: nil, action: nil)
        leftBarButton.tintColor = .white
        rightBarButton.tintColor = .white
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

}

extension NewsFeedsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storyArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.friendCollectionViewCellIdentifier,
            for: indexPath) as? FriendCollectionViewCell else {
                return UICollectionViewCell()
        }
        cell.setContent(storyModel: storyArray[indexPath.row])
        return cell
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
        let lastElement = feedsTempArray.count - 1
        if indexPath.row == lastElement {
            let beginElement = feedsTempArray.count
            var endElement = 0
            if feedsArray.count > (feedsTempArray.count + Constants.numberNewsFeedShow) {
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: Constants.loadMoreTableViewCellIdentifier)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return feedsArray.count == feedsTempArray.count ? 0.0001 : Constants.heightLoadMoreCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

extension NewsFeedsViewController: NewsFeedTableViewCellDelegate {

    func clickLikeButton(indexPath: IndexPath) {
        newsFeedTableView.beginUpdates()
        if feedsTempArray[indexPath.row].isReacted {
            feedsTempArray[indexPath.row].reactionCount -= 1
            feedsTempArray[indexPath.row].isReacted = false
        } else {
            feedsTempArray[indexPath.row].reactionCount += 1
            feedsTempArray[indexPath.row].isReacted = true
        }
        newsFeedTableView.reloadRows(at: [indexPath], with: .none)
        newsFeedTableView.endUpdates()
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

    func tapToAvatar() {
        guard let profileViewController = storyboard?.instantiateViewController(
            withIdentifier: Constants.profileViewControllerIdentifier) as? ProfileViewController else {
                return
        }
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
