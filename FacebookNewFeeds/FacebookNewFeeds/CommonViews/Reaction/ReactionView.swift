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
    public static let movingSpeed: CGFloat = 20
}

enum Aligment {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

protocol ReactionViewDelegate: class {
    func selectedReaction(reactionType: String, startPoint: CGPoint, endPoint: CGPoint, image: UIImage)
    func removeReactionView()
}

class ReactionView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var reactionAction: [UIButton]!
    @IBOutlet weak var reactionView: UIView!
    weak var delegate: ReactionViewDelegate?
    var alignment = Aligment.topLeft
    var reactions: [String] = [ReactionType.like, ReactionType.love, ReactionType.wow, ReactionType.sad,
                               ReactionType.angry, ReactionType.haha]
    var position: CGPoint = .zero

    init(view: UIView, alignment: Aligment, position: CGPoint) {
        super.init(frame: view.frame)
        commonInit()
        self.alignment = alignment
        var frame = reactionView.frame
        let width = reactionView.frame.width
        let height = reactionView.frame.height
        switch alignment {
        case .topRight:
            frame = CGRect(x: view.frame.width - width - Constants.padding, y: position.y - Constants.margin - height,
                width: width, height: height)
        case .topLeft:
            frame = CGRect(x: Constants.padding, y: position.y - Constants.margin - height,
                width: width, height: height)
        case .bottomLeft:
            frame = CGRect(x: Constants.padding, y: position.y + Constants.margin,
                width: width, height: height)
        case .bottomRight:
            frame = CGRect(x: view.frame.width - width - Constants.padding, y: position.y + Constants.margin,
                           width: width, height: height)
        }
        reactionView.changeFrame(frame: frame)
        self.position = position
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
        reactionView.layer.cornerRadius = Constants.cornerRadius
        for index in 0...reactionAction.count - 1 {
            reactionAction[index].tag = index
            reactionAction[index].addTarget(self, action: #selector(touchOn(button:)), for: .touchUpInside)
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeAnimate)))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      removeAnimate()
    }

    func showAnimate() {
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
            if self.alignment == .topLeft || self.alignment == .topRight {
                self.reactionView.frame.origin.y -= Constants.movingSpeed
            } else {
                self.reactionView.frame.origin.y += Constants.movingSpeed
            }
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
            let xPosition = self.reactionView.frame.origin.x +
                self.reactionView.frame.width * CGFloat(button.tag) / CGFloat(self.reactions.count)
            guard let imageView = button.imageView, let image = imageView.image else {
                return
            }
            self.delegate?.selectedReaction(reactionType: self.reactions[button.tag],
                startPoint: CGPoint(x: xPosition, y: self.reactionView.frame.origin.y),
                endPoint: self.position, image: image)
            self.removeAnimate()
        })
    }

    @objc func removeAnimate() {
        UIView.animate(withDuration: CommonConstants.timeDurationAnimate, animations: {
            if self.alignment == .topLeft || self.alignment == .topRight {
                self.reactionView.frame.origin.y += Constants.movingSpeed
            } else {
                self.reactionView.frame.origin.y -= Constants.movingSpeed
            }
        }, completion: { (_) in
            self.removeFromSuperview()
            self.delegate?.removeReactionView()
        })
    }

}
