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
    public static let infoTableViewCellIdentifier = "InfoTableViewCell"
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var myFeedsTableView: UILoadingTableView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var heightInfoTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.update(textFieldPlaceHolder: "Search",
                             textFieldBackground: CommonConstants.colorSearchBarBackground,
                             textFieldColor: CommonConstants.colorTextFieldPlaceHolder)
        }
    }
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var profileModel: ProfileModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.infoTableViewCellIdentifier)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        myFeedsTableView.register(UINib(nibName: Constants.newsFeedTableViewCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.newsFeedTableViewCellIdentifier)
        myFeedsTableView.dataSource = self
        myFeedsTableView.delegate = self
        scrollView.delegate = self
        setProfileToView()
        let spinner = UIViewController.displaySpinner(onView: myFeedsTableView.loadingView)
        QueryService.get(url: Url.profileUrl, success: { (response) in
            guard let responseProfile = response["profile"] as? [String: Any] else {
                return
            }
            self.profileModel = ProfileModel(response: responseProfile)
            DispatchQueue.main.async {
                self.setProfileToView()
            }
            UIViewController.removeSpinner(spinner: spinner)
        }, failure: { (_) in
            UIViewController.removeSpinner(spinner: spinner)
        })
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(backButtonAction))
        backImageView.addGestureRecognizer(tapGuesture)
        backImageView.isUserInteractionEnabled = true
    }

    private func setProfileToView() {
        guard let profileModel = profileModel else {
            return
        }
        fullNameLabel.text = profileModel.fullName
        guard let avatarUrl = profileModel.avatarUrl else {
            return
        }

        avatarImageView.setImageFromStringURL(stringURL: avatarUrl)
        guard let coverUrl = profileModel.coverUrl else {
            return
        }
        coverImageView.setImageFromStringURL(stringURL: coverUrl)
        myFeedsTableView.reloadData()
        infoTableView.reloadData()
    }

    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = scrollView.contentOffset.y < 0 ? false: true
    }

}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let profileModel = profileModel else {
            return 0
        }
        if tableView == myFeedsTableView {
            return profileModel.feeds.count
        } else if tableView == infoTableView {
            return profileModel.infos.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileModel = profileModel else {
            return UITableViewCell()
        }
        if tableView == myFeedsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsFeedTableViewCellIdentifier,
                for: indexPath) as? NewsFeedTableViewCell else {
                return UITableViewCell()
            }

            let feedModel = profileModel.feeds[indexPath.row]
            cell.setContent(feedModel: feedModel, indexPath: indexPath)
            return cell
        } else if tableView == infoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoTableViewCellIdentifier,
                for: indexPath)
            let infoModel = profileModel.infos[indexPath.row]
            guard let key = infoModel.key, let value = infoModel.value, let icon = infoModel.icon else {
                return cell
            }
            cell.textLabel?.font = UIFont.systemFont(ofSize: CommonConstants.normalFontSize)
            cell.textLabel?.text =  key + " " + value
            cell.imageView?.image = UIImage(named: icon)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightTableViewConstraint.constant = myFeedsTableView.contentSize.height
        heightInfoTableViewConstraint.constant = infoTableView.contentSize.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }

}
