//
//  StoryModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/31/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class StoryModel: NSObject {
    var storyImageUrl: String?
    var fullName: String?

    override init() {
        super.init()
    }

    init(response: [String: Any]) {
        super.init()
        if let storyImageUrl = response["storyImageUrl"] as? String {
            self.storyImageUrl = storyImageUrl
        }
        if let fullName = response["fullName"] as? String {
            self.fullName = fullName
        }
    }
}
