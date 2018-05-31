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
    public static let url = "https://www.mocky.io/v2/5b0ce0cb3300005100b400f1"
}

class NewsFeedsViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var newsFeedTableView: UITableView!
    var feedsArray = [FeedModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarItems()
        friendsCollectionView.dataSource = self
        friendsCollectionView.register(UINib.init(nibName: Constants.friendCollectionViewCellNibName, bundle: nil),
                                       forCellWithReuseIdentifier: Constants.friendCollectionViewCellIdentifier)
        newsFeedTableView.dataSource = self
        newsFeedTableView.register(UINib.init(nibName: Constants.newsFeedTableViewCellNibName, bundle: nil),
                                       forCellReuseIdentifier: Constants.newsFeedTableViewCellIdentifier)
        QueryService.get(url: Constants.url) { (response) in
            guard let responseData = response["feeds"] as? [[String: Any]] else {
                return
            }
            for feed in responseData {
                let feedModel = FeedModel.init(response: feed)
                self.feedsArray.append(feedModel)
            }
        }
    }

    private func setUpNavigationBarItems() {
        let searchBar = UISearchBar.init(frame: .zero)
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "camera"), style: .done, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .done, target: nil, action: nil)
        leftBarButton.tintColor = .white
        rightBarButton.tintColor = .white
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

}

extension NewsFeedsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                Constants.friendCollectionViewCellIdentifier, for: indexPath)
        return cell
    }

}

extension NewsFeedsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsFeedTableViewCellIdentifier,
                                                       for: indexPath) as? NewsFeedTableViewCell else{
        return UITableViewCell()
        }
        cell.setContent()
        return cell
    }

}
