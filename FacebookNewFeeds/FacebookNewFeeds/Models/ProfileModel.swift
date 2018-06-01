//
//  ProfileModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/1/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    var fullName: String?
    var avatarUrl: String?
    var coverUrl: String?
    var workAt: String?
    var studiedAt: String?
    var liveIn: String?
    var from: String?
    var feeds = [FeedModel]()

    override init() {
        super.init()
    }

    init(response: [String: Any]) {
        super.init()
        if let fullName = response["fullName"] as? String {
            self.fullName = fullName
        }
        if let avatarUrl = response["avatarUrl"] as? String {
            self.avatarUrl = avatarUrl
        }
        if let coverUrl = response["coverUrl"] as? String {
            self.coverUrl = coverUrl
        }
        if let workAt = response["workAt"] as? String {
            self.workAt = workAt
        }
        if let studiedAt = response["studiedAt"] as? String {
            self.studiedAt = studiedAt
        }
        if let liveIn = response["liveIn"] as? String {
            self.liveIn = liveIn
        }
        if let from = response["from"] as? String {
            self.from = from
        }
        if let feeds = response["feeds"] as? [[String: Any]] {
            for feed in feeds {
                let feedModel = FeedModel(response: feed)
                self.feeds.append(feedModel)
            }
        }
    }

}
