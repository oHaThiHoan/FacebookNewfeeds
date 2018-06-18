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
    var feeds = [FeedModel]()
    var infos = [InfoModel]()
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

        if let infos = response["infos"] as? [String: String] {
            for info in infos {
                let infoModel = InfoModel(key: info.key, value: info.value)
                self.infos.append(infoModel)
            }
        }

        if let feeds = response["feeds"] as? [[String: Any]] {
            for feed in feeds {
                let feedModel = FeedModel(response: feed)
                self.feeds.append(feedModel)
            }
        }
    }

}
