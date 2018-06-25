//
//  PhotoShowViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/20/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class PhotoShowViewController: UIViewController {

    var feedTitleModel: FeedModel?
    var feedModel: FeedModel? {
        didSet {
            feedTitleModel = feedModel?.copy()
            feedTitleModel?.feedImages?.removeAll()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var swipeGesture = UISwipeGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibName: NewsFeedTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView))
        tableView.addGestureRecognizer(swipeGesture)
        swipeGesture.direction = .right
    }

    @objc func swipeView() {
       navigationController?.popViewController(animated: true)
    }

}

extension PhotoShowViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1, let feedModel = feedModel, let feedImages = feedModel.feedImages {
            return feedImages.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NewsFeedTableViewCell.self)
        if indexPath.section == 0, let feedTitleModel = feedTitleModel {
            cell.setContent(feedModel: feedTitleModel, indexPath: indexPath, view: view)
        } else if indexPath.section == 1, let feedModel = feedModel, let feedImages = feedModel.feedImages {
            cell.setContent(attachImage: feedImages[indexPath.row], indexPath: indexPath, view: view)
        }
        return cell
    }

}

extension PhotoShowViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightTableViewConstraint.constant = tableView.contentSize.height
    }

}
