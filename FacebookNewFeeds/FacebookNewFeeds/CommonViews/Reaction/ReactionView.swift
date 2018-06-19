//
//  ReactionView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/19/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let ReactionViewNibName = "ReactionView"
    public static let sizeItem = 50
    public static let cornerRadius: CGFloat = 25
    public static let margin: CGFloat = 50
    public static let padding: CGFloat = 8
}

enum Aligment {
    case right
    case left
    case top
    case bottom
}

protocol ReactionViewDelegate: class {
    func selectedReaction(reactionType: String)
}

class ReactionView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var reactionAction: [UIButton]!
    public var width: CGFloat = 296
    public var height: CGFloat = 58
    weak var delegate: ReactionViewDelegate?
    var reactions: [String] = [ReactionType.like, ReactionType.love, ReactionType.wow, ReactionType.sad,
                               ReactionType.angry, ReactionType.haha]

    init(view: UIView, alignment: Aligment) {
        var frame: CGRect = .zero
        switch alignment {
        case .right:
            frame = CGRect(x: view.frame.width - width - Constants.padding, y: view.frame.width - Constants.margin,
                width: width + Constants.padding, height: height)
        case .left:
            frame = CGRect(x: Constants.padding, y: view.frame.width - Constants.margin,
                width: width + Constants.padding, height: height)
        case .bottom:
            frame = CGRect(x: 0, y: Constants.margin,
                width: width + Constants.padding, height: height)
        default:
            frame = .zero
        }
        super.init(frame: frame)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(Constants.ReactionViewNibName, owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = Constants.cornerRadius
        for index in 0...reactionAction.count - 1 {
            reactionAction[index].tag = index
            reactionAction[index].addTarget(self, action: #selector(touchOn(button:)), for: .touchUpInside)
        }
    }

    func showAnimate() {
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
            self.view.frame.origin.y -= 20
        })
    }

    @objc func touchOn(button: UIButton) {
        button.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewAnimate,
            y: CommonConstants.scaleViewAnimate)
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate) {
            button.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewDefault,
                y: CommonConstants.scaleViewDefault)
        }
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
            button.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewDefault,
                y: CommonConstants.scaleViewDefault)
        }, completion: { (_) in
            self.delegate?.selectedReaction(reactionType: self.reactions[button.tag])
            self.removeAnimate()
        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame.origin.y += 20
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }

}
