//
//  UISearchBar.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/4/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension UISearchBar {

    public convenience init(frame: CGRect, textFieldPlaceHolder: String, textFieldBackground: UIColor,
                            textFieldColor: UIColor) {
        self.init(frame: frame)
        let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = textFieldColor
        textFieldInsideSearchBar?.backgroundColor = textFieldBackground
        textFieldInsideSearchBar?.placeholder = textFieldPlaceHolder
    }

}
