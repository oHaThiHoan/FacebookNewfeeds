//
//  NewFeedsViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/29/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class NewFeedsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarItems()
    }

    private func setUpNavigationBarItems() {
        let searchBar = UISearchBar.init(frame: .zero)
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "camera"), style: .plain, target: nil, action: nil)
          let rightBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "message"), style: .plain, target: nil, action: nil)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }

}
