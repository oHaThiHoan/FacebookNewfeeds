//
//  CommentModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/12/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    var avatarUrl: String?
    var fullName: String?
    var comment: String?

    init(response: [String: Any]) {
        super.init()
        if let fullName = response["fullName"] as? String {
            self.fullName = fullName
        }
        if let avatarUrl = response["avatarUrl"] as? String {
            self.avatarUrl = avatarUrl
        }
        if let comment = response["comment"] as? String {
            self.comment = comment
        }
    }

    init(avatarUrl: String?, fullName: String?, comment: String) {
        self.avatarUrl = avatarUrl
        self.fullName = fullName
        self.comment = comment
    }
}
