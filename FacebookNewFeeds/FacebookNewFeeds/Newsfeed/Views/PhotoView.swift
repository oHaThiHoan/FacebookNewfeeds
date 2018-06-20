//
//  PhotoView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/8/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let photoViewNibName = "PhotoView"
    public static let restLabelColor: UIColor = .white
    public static let restLabelX: CGFloat = UIScreen.main.bounds.width / 4

    public static let restLableWidth: CGFloat = 50
    public static let restLabelHeight: CGFloat = 50
    public static let ratioImageVertical: Double = 16 / 9
    public static let ratioImageRectagle: Double = 1
    public static let space: CGFloat = 1
}

enum PhotoLayout {
    case oneVerticalTwoHorizontal
    case oneHorizontalTwoVertical
    case oneVerticalThreeHorizontal
    case twoVerticalTwoHorizontal
}

class PhotoView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    var photoLayout: PhotoLayout?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(Constants.photoViewNibName, owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
    }

    public func addImageToStackView (images: [AttachImageModel]) {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
        if images.count == 1 {
            stackView.addArrangedSubview(AttactImage(attachModel: images[0]).itemView)
        } else if images.count == 2 {
            stackView.addArrangedSubview(AttactImage(attachModel: images[0]).itemView)
            stackView.addArrangedSubview(AttactImage(attachModel: images[1]).itemView)
        } else if images.count == 3 {
            let subStackView = createStackViewWith(axis: .vertical)
            subStackView.addArrangedSubview(AttactImage(attachModel: images[1]).itemView)
            subStackView.addArrangedSubview(AttactImage(attachModel: images[2]).itemView)
            stackView.addArrangedSubview(AttactImage(attachModel: images[0]).itemView)
            stackView.addArrangedSubview(subStackView)
        } else if images.count >= 4 {
            stackView.axis = .horizontal
            let aboveStackView = createStackViewWith(axis: .vertical)
            aboveStackView.addArrangedSubview(AttactImage(attachModel: images[0]).itemView)
            aboveStackView.addArrangedSubview(AttactImage(attachModel: images[1]).itemView)
            let belowStackView = createStackViewWith(axis: .vertical)
            belowStackView.addArrangedSubview(AttactImage(attachModel: images[2]).itemView)
            let lastImageView = AttactImage(attachModel: images[3]).itemView
            if images.count > 4 {
                lastImageView.addSubview(createRestLabel(restNumber: "+\(images.count - 4)"))
            }
            belowStackView.addArrangedSubview(lastImageView)
            stackView.addArrangedSubview(aboveStackView)
            stackView.addArrangedSubview(belowStackView)
        }
    }

    private func createStackViewWith(axis: UILayoutConstraintAxis) -> UIStackView {
        let subStackView = UIStackView()
        subStackView.distribution = .fillEqually
        subStackView.spacing = Constants.space
        subStackView.axis = axis
        return subStackView
    }

    private func createRestLabel(restNumber: String) -> UILabel {
        let restLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        restLabel.text = restNumber
        restLabel.textAlignment = .center
        restLabel.textColor = Constants.restLabelColor
        return restLabel
    }

}
