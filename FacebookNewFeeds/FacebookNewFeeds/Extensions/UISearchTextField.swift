//
//  UISearchTextField.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/14/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let leftMarginSearchIcon: CGFloat = 15
    public static let widthSearchIcon: CGFloat = 15
    public static let heightSearchIcon: CGFloat = 15
    public static let placeHolderColorDefault: UIColor = .white
}

class UISearchTextField: UITextField {

    var attribute = AttributeTextField() {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        setNeedsLayout()
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += Constants.leftMarginSearchIcon
        textRect.size.width = Constants.widthSearchIcon
        textRect.size.height = Constants.heightSearchIcon
        return textRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.size.height = Constants.heightSearchIcon
        rect.size.width = Constants.widthSearchIcon
        rect.origin.x -= Constants.leftMarginSearchIcon
        return rect
    }

    private func update() {
        attributedPlaceholder = NSAttributedString(string: attribute.placeHolderText,
            attributes: [NSAttributedStringKey.foregroundColor: attribute.placeHolderColor])
        leftView = UIImageView(image: #imageLiteral(resourceName: "search icon").transform(withNewColor: attribute.placeHolderColor))
        leftViewMode = .always
        rightView = UIImageView(image: #imageLiteral(resourceName: "cancel").transform(withNewColor: attribute.placeHolderColor))
        rightViewMode = .whileEditing
    }

}

class AttributeTextField {

    public typealias AttributeBlock = (AttributeTextField) -> Void
    var placeHolderText = ""
    var placeHolderColor: UIColor = Constants.placeHolderColorDefault

    public init(block: AttributeBlock) {
        block(self)
    }

    init() {}

}
