//
//  NewsFeedTableViewCell.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let imageAttachCollectionViewCellNibName = "ImageAttachCollectionViewCell"
    public static let imageAttachCollectionViewCellIdentifier = "ImageAttachCollectionViewCell"
    public static let heightCollectionView = 150
}

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var heightImageAttachCollectionView: NSLayoutConstraint!
    let numberImageAttach = 7

    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib.init(nibName: Constants.imageAttachCollectionViewCellNibName, bundle: nil),
                                     forCellWithReuseIdentifier: Constants.imageAttachCollectionViewCellIdentifier)
    }

    public func setContent() {
        if numberImageAttach == 0 {
            heightImageAttachCollectionView.constant = 0
        }
    }

}

extension NewsFeedTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberImageAttach
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            Constants.imageAttachCollectionViewCellIdentifier, for: indexPath) as? ImageAttachCollectionViewCell else {
                return UICollectionViewCell()
        }
        if indexPath.row == 3 && numberImageAttach > 4 {
            let restOfImageAttach = numberImageAttach - 4
            cell.setRestOfImageAttach(number: restOfImageAttach)
        }
        return cell
    }

}

extension NewsFeedTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        if  numberImageAttach == 0 {
            width = 0
            height = 0
        } else if numberImageAttach <= 2 {
            width = UIScreen.main.bounds.width / CGFloat(numberImageAttach) - CGFloat(5 * (numberImageAttach + 1))
            height = CGFloat(Constants.heightCollectionView)
        } else {
            width = UIScreen.main.bounds.width / CGFloat(2) - 15
            height = CGFloat(Constants.heightCollectionView / 2)
        }
        return CGSize(width: width, height: height)
    }

}
