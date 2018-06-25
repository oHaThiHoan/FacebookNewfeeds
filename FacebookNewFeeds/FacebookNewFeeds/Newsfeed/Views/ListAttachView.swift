//
//  PhotoView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/8/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let listAttachView = "ListAttachView"
    public static let restLabelColor: UIColor = .white
    public static let restLabelX: CGFloat = UIScreen.main.bounds.width / 4

    public static let restLableWidth: CGFloat = 50
    public static let restLabelHeight: CGFloat = 50
    public static let ratioImageVertical: Double = 16 / 9
    public static let ratioImageRectagle: Double = 1
    public static let space: CGFloat = 1
}

class ListAttachView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    var actionTapOnPhoto: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(Constants.listAttachView, owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        translatesAutoresizingMaskIntoConstraints = false
    }

    public func addImageToStackView (images: [AttachModel]) {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
        if images.count == 1 {
            stackView.addArrangedSubview(createAttachImage(attachModel: images[0]))
        } else if images.count == 2 {
            stackView.addArrangedSubview(createAttachImage(attachModel: images[0]))
            stackView.addArrangedSubview(createAttachImage(attachModel: images[1]))
        } else if images.count == 3 {
            let subStackView = createStackViewWith(axis: .vertical)
            subStackView.addArrangedSubview(createAttachImage(attachModel: images[1]))
            subStackView.addArrangedSubview(createAttachImage(attachModel: images[2]))
            stackView.addArrangedSubview(createAttachImage(attachModel: images[0]))
            stackView.addArrangedSubview(subStackView)
        } else if images.count >= 4 {
            stackView.axis = .horizontal
            let aboveStackView = createStackViewWith(axis: .vertical)
            aboveStackView.addArrangedSubview(createAttachImage(attachModel: images[0]))
            aboveStackView.addArrangedSubview(createAttachImage(attachModel: images[1]))
            let belowStackView = createStackViewWith(axis: .vertical)
            belowStackView.addArrangedSubview(createAttachImage(attachModel: images[2]))
            if images.count > 4 {
                belowStackView.addArrangedSubview(createAttachImage(attachModel: images[3],
                    text: "+\(images.count - 4)"))
            } else {
                belowStackView.addArrangedSubview(createAttachImage(attachModel: images[3]))
            }
            stackView.addArrangedSubview(aboveStackView)
            stackView.addArrangedSubview(belowStackView)
        }
    }

    private func createAttachImage(attachModel: AttachModel, text: String = "") -> UIView {
        let attachImage = AttachView(attachModel: attachModel, text: text) { [weak self] in
            if let action = self?.actionTapOnPhoto {
                action()
            }
        }
        return attachImage.itemView
    }

    private func createStackViewWith(axis: UILayoutConstraintAxis) -> UIStackView {
        let subStackView = UIStackView()
        subStackView.distribution = .fillEqually
        subStackView.spacing = Constants.space
        subStackView.axis = axis
        return subStackView
    }

}
