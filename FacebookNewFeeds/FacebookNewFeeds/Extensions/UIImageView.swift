//
//  ImageView+Customs.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/31/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {

    func setImageFromStringURL(stringURL: String) {
        if let url = URL(string: stringURL) {
            sd_setImage(with: url, completed: nil)
        }
    }

}
