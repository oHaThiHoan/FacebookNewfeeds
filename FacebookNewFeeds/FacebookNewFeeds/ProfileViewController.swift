//
//  ProfileViewController.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/1/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let newsFeedTableViewCellNibName = "NewsFeedTableViewCell"
    public static let newsFeedTableViewCellIdentifier = "NewsFeedTableViewCell"
    public static let profileUrl = "https://www.mocky.io/v2/5b1111622f0000700034f21e"
    public static let colorSearchBarBackground = "#2E4780"
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var studiedLocationLabel: UILabel!
    @IBOutlet weak var liveLocationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var myFeedsTableView: UITableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    var profileModel = ProfileModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        myFeedsTableView.register(UINib(nibName: Constants.newsFeedTableViewCellNibName, bundle: nil),
                                  forCellReuseIdentifier: Constants.newsFeedTableViewCellIdentifier)
        myFeedsTableView.dataSource = self
        myFeedsTableView.delegate = self
        QueryService.get(context: self, url: Constants.profileUrl) { (response) in
            guard let responseProfile = response["profile"] as? [String: Any] else {
                return
            }
            self.profileModel = ProfileModel(response: responseProfile)
            DispatchQueue.main.async {
                self.setProfileToView()
            }
        }
    }

    private func setProfileToView() {
        guard let coverUrl = profileModel.coverUrl else {
            return
        }
        coverImageView.setImageFromStringURL(stringURL: coverUrl)
        guard let avatarUrl = profileModel.avatarUrl else {
            return
        }
        avatarImageView.setImageFromStringURL(stringURL: avatarUrl)
        fullNameLabel.text = profileModel.fullName
        workLocationLabel.text = profileModel.workAt
        liveLocationLabel.text = profileModel.liveIn
        fromLocationLabel.text = profileModel.from
        self.myFeedsTableView.reloadData()
    }

    private func setNavigationItem() {
        let searchBar = UISearchBar(frame: .zero, textFieldPlaceHolder: "Search",
            textFieldBackground: UIColor(hexString: Constants.colorSearchBarBackground ), textFieldColor: .white)
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "message"),
            style: .done, target: nil, action: nil)
        rightBarButton.tintColor = .white
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.topItem?.title = " "
    }

    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return profileModel.feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsFeedTableViewCellIdentifier,
            for: indexPath) as? NewsFeedTableViewCell else {
            return UITableViewCell()
        }
        let feedModel = profileModel.feeds[indexPath.row]
        cell.setContent(feedModel: feedModel)
        return cell
    }

}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightTableViewConstraint.constant = myFeedsTableView.contentSize.height
    }

}
