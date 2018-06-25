//
//  UISearchBar.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/4/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension UISearchBar {

    func update(textFieldPlaceHolder: String, textFieldBackground: UIColor, textFieldColor: UIColor) {
        let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.tintColor = textFieldColor
        textFieldInsideSearchBar?.textColor = textFieldColor
        textFieldInsideSearchBar?.backgroundColor = textFieldBackground
        textFieldInsideSearchBar?.placeholder = textFieldPlaceHolder
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder,
            attributes: [NSAttributedStringKey.foregroundColor: textFieldColor])
        if  let leftView = textFieldInsideSearchBar?.leftView as? UIImageView {
            leftView.image = leftView.image?.transform(withNewColor: textFieldColor)
        }
        backgroundImage = UIImage()
    }

}
