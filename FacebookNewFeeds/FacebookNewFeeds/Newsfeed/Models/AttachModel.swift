//
//  AttachImageModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/21/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class AttachModel: NSObject {
    var type = ""
    var url = ""
    var reactionCount = 0
    var commentCount = 0
    var sharingCount = 0
    var reaction: String?

    init(with response: [String: Any]) {
        super.init()
        if let type = response["type"] as? String {
            self.type = type
        }
        if let url = response["url"] as? String {
            self.url = url
        }
        if let reactionCount = response["reactionCount"] as? Int {
            self.reactionCount = reactionCount
        }
        if let commentCount = response["commentCount"] as? Int {
            self.commentCount = commentCount
        }
        if let sharingCount = response["sharingCount"] as? Int {
            self.sharingCount = sharingCount
        }
        if let reaction = response["reaction"] as? String {
            self.reaction = reaction
        }
    }

}
