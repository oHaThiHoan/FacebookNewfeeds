//
//  AnimateImageView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/26/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class AnimateImageView: UIImageView {

    var didStopAnimate: (() -> Void)?

    func moveCurve(startPoint: CGPoint, endPoint: CGPoint) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        let xPosition = startPoint.x >  endPoint.x ? startPoint.x / 3 : endPoint.x / 3 + startPoint.x
        let yPosition = startPoint.x > endPoint.x ? startPoint.y - 100 : startPoint.y + 100
        path.addQuadCurve(to: endPoint, controlPoint: CGPoint(x: xPosition, y: yPosition))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 0.6
        animation.delegate = self
        layer.add(animation, forKey: "curve animate")
    }

}

extension AnimateImageView: CAAnimationDelegate {

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let action = didStopAnimate {
            action()
            removeFromSuperview()
        }
    }

}
