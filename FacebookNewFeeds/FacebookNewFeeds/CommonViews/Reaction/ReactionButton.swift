//
//  ReactionButton.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/19/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let ReactionNibName = "ReactionButton"
}

protocol ReactionButtonDelegate: class {
    func changeValue()
}

class ReactionButton: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var parentView: UIView?
    var isShowed = false
    var isSelected = false
    var reactionType = ReactionType.none {
        didSet {
            update(reactionType: reactionType)
        }
    }
    weak var delegate: ReactionButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(Constants.ReactionNibName, owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTap)))
    }

    @objc func longTap() {
        if let parentView = parentView, !isShowed {
            let reactionView = ReactionView(view: parentView, alignment: .left)
            parentView.addSubview(reactionView)
            reactionView.showAnimate()
            reactionView.delegate = self
            isShowed = true
        }
    }

    @IBAction func reactionAction(_ sender: Any) {
        if isSelected {
            isSelected = false
            reactionType = ReactionType.none
        } else {
            isSelected = true
            reactionType = ReactionType.like
            image.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewAnimate,
                y: CommonConstants.scaleViewAnimate)
            UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
                self.image.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewDefault,
                    y: CommonConstants.scaleViewDefault)
            })
        }
        self.delegate?.changeValue()
    }

    func update(reactionType: String) {
        if let image = ReactionAsset.iconAssets[reactionType] {
            self.image.image = image
        }
        if let text = ReactionAsset.labelAssets[reactionType] {
            label.text = text
        }
        if let color = ReactionAsset.colorAssets[reactionType] {
            label.textColor =  color
        }
    }

}

extension ReactionButton: ReactionViewDelegate {

    func selectedReaction(reactionType: String) {
        self.reactionType = reactionType
        image.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewAnimate,
            y: CommonConstants.scaleViewAnimate)
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
            self.image.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewDefault,
                y: CommonConstants.scaleViewDefault)
        }, completion: { (finish) in
            if finish {
                self.isSelected = true
                self.isShowed = false
                self.delegate?.changeValue()
            }
        })
    }

}
