//
//  UICollectionView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/26/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil)
        where T: ReusableView {
            let identifier = T.defaultReuseIdentifier
            let nibName = T.nibName
            var bundle: Bundle? = nil
            if let bundleName = bundleClass {
                bundle = Bundle(for: bundleName)
            }
            register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T
        where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath)
            as? T else {
                fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

}
