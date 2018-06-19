//
//  PopUpView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/18/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

private struct Constants {
    public static let popUpViewNibName = "PopUpView"
}

class PopUpView: UIView {

    @IBOutlet var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(Constants.popUpViewNibName, owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    func showPopUpView(animate: Bool) {
        view.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewAnimate,
                                           y: CommonConstants.scaleViewAnimate)
        view.alpha = 0.0
        if animate {
            UIView.animate(withDuration: CommonConstants.timeDurationAnimate) {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: CommonConstants.scaleViewDefault,
                                                        y: CommonConstants.scaleViewDefault)
            }
        }
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }, completion: { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        })
    }

    @IBAction func closeAction(_ sender: Any) {
        removeAnimate()
    }

}
