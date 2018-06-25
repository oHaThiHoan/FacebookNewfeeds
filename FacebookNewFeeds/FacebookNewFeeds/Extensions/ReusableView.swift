//
//  ReusableView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/26/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var nibName: String {get}
    static var defaultReuseIdentifier: String {get}
}

extension ReusableView where Self: UIView {

    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }

    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

}
