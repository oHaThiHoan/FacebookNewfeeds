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
        view.frame = self.bounds
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
    }

    public func addImageToStackView (images: [String]) {
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
        if images.count == 1 {
            addOneImage(image: images[0], toStackView: stackView)
        } else if images.count == 2 {
            for index in 0...1 {
                addOneImage(image: images[index], toStackView: stackView)
            }
        } else if images.count == 3 {
            addThreeImage(images: images, toStackView: stackView)
        } else if images.count >= 4 {
            addFourImage(images: images, toStackView: stackView)
        }
    }

    private func addOneImage(image: String, toStackView: UIStackView) {
        let imageView = UIImageView()
        imageView.setImageFromStringURL(stringURL: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        toStackView.addArrangedSubview(imageView)
    }

    private func addThreeImage(images: [String], toStackView: UIStackView) {
        var attachImageArray: [AttactImage] = []
        var firstImageView = AttactImage(url: images[0])
        var firstImageViewIndex = 0
        for index in 0...2 {
            let attachImage = AttactImage(url: images[index])
            attachImageArray.append(attachImage)
            if attachImage.ratio < firstImageView.ratio {
                firstImageView = attachImage
                firstImageViewIndex = index
            }
        }
        attachImageArray.remove(at: firstImageViewIndex)
        attachImageArray.insert(firstImageView, at: 0)
        if firstImageView.ratio > Constants.ratioImageVertical {
            photoLayout = PhotoLayout.oneVerticalTwoHorizontal
        } else {
            photoLayout = PhotoLayout.oneHorizontalTwoVertical
        }
        guard let photoLayout = photoLayout else {
            return
        }
        drawImage(images: attachImageArray, photoLayout: photoLayout, stackView: stackView)
    }

    private func drawImage( images: [AttactImage], photoLayout: PhotoLayout, stackView: UIStackView) {
        if photoLayout == PhotoLayout.oneHorizontalTwoVertical {
            let righStackView = initStackView()
            righStackView.axis = .vertical
            stackView.axis = .horizontal
            stackView.addArrangedSubview(images[0].imageView)
            righStackView.addArrangedSubview(images[1].imageView)
            righStackView.addArrangedSubview(images[2].imageView)
            stackView.addArrangedSubview(righStackView)
        } else if photoLayout == PhotoLayout.oneVerticalTwoHorizontal {
            let righStackView = initStackView()
            righStackView.axis = .horizontal
            stackView.axis = .vertical
            stackView.addArrangedSubview(images[0].imageView)
            righStackView.addArrangedSubview(images[1].imageView)
            righStackView.addArrangedSubview(images[2].imageView)
            stackView.addArrangedSubview(righStackView)
        } else if photoLayout == PhotoLayout.twoVerticalTwoHorizontal {
            let aboveStackView = initStackView()
            aboveStackView.axis = .vertical
            aboveStackView.addArrangedSubview(images[0].imageView)
            aboveStackView.addArrangedSubview(images[1].imageView)
            let belowStackView = initStackView()
            belowStackView.axis = .vertical
            belowStackView.addArrangedSubview(images[2].imageView)
            let lastImageView = images [3].imageView
            lastImageView.addSubview(initRestLabel(restNumber: (images.count - 4), imageView: lastImageView))
            belowStackView.addArrangedSubview(lastImageView)
            stackView.addArrangedSubview(aboveStackView)
            stackView.addArrangedSubview(belowStackView)
        } else if photoLayout == PhotoLayout.oneVerticalThreeHorizontal {
            stackView.addArrangedSubview(images[0].imageView)
            let rightStackView =  initStackView()
            rightStackView.axis = .vertical
            rightStackView.addArrangedSubview(images[1].imageView)
            rightStackView.addArrangedSubview(images[2].imageView)
            let lastImageView = images [3].imageView
            lastImageView.addSubview(initRestLabel(restNumber: (images.count - 4), imageView: lastImageView))
            rightStackView.addArrangedSubview(lastImageView)
            stackView.addArrangedSubview(rightStackView)
        }
    }

    private func addFourImage(images: [String], toStackView: UIStackView) {
        var attachImageArray: [AttactImage] = []
        var firstImageView = AttactImage(url: images[0])
        var firstImageViewIndex = 0
        for index in 0...3 {
            let attachImage = AttactImage(url: images[index])
            attachImageArray.append(attachImage)
            if attachImage.ratio < firstImageView.ratio {
                firstImageView = attachImage
                firstImageViewIndex = index
            }
        }
        if firstImageView.ratio == Constants.ratioImageRectagle {
            photoLayout = PhotoLayout.twoVerticalTwoHorizontal
        } else {
            attachImageArray.remove(at: firstImageViewIndex)
            attachImageArray.insert(firstImageView, at: 0)
            photoLayout = PhotoLayout.oneVerticalThreeHorizontal
        }
        guard let photoLayout = photoLayout else {
            return
        }
        drawImage(images: attachImageArray, photoLayout: photoLayout, stackView: toStackView)
    }

    private func initStackView() -> UIStackView {
        let subStackView = UIStackView()
        subStackView.distribution = .fillEqually
        subStackView.spacing = 1
        return subStackView
    }

    private func initRestLabel(restNumber: Int, imageView: UIImageView) -> UILabel {
        let restLabel = UILabel(frame: CGRect(x: Constants.restLabelX,
             y: imageView.frame.height / 2, width: Constants.restLableWidth, height: Constants.restLabelHeight))
        if restNumber > 0 {
            restLabel.text = String(restNumber)
        }
        restLabel.textColor = Constants.restLabelColor
        return restLabel
    }

}
