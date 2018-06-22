//
//  String.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/20/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension String {

    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }

    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }

}
