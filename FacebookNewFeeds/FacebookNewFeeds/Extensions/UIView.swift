//
//  UIView.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/20/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension UIView {

    func changeFrame(frame: CGRect) {
        UIView.animate(withDuration: 0.1, animations: {
        }, completion: { _ in
            self.frame = frame
        })
    }

}
