//
//  UITableView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/26/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(nibName name: T.Type, atBundle bundleClass: AnyClass? = nil)
        where T: ReusableView {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle? = nil
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T where T: ReusableView {
        guard let cell =  self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

    func register<T: UITableViewHeaderFooterView> (nibName name: T.Type, atBundle bundleClass: AnyClass? = nil)
        where T: ReusableView {
        let identifier = T.defaultReuseIdentifier
        let nibName = T.nibName
        var bundle: Bundle? = nil
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        register(UINib(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T where T: ReusableView {
        guard let cell =  self.dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }

}
