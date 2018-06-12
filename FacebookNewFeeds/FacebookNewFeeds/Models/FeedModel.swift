//
//  FeedModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class FeedModel: NSObject {

    var fullName: String?
    var avatarURL: String?
    var createAt: String?
    var feedContent: String?
    var visibleMode: String?
    var reactionCount = 0
    var commentCount = 0
    var sharingCount = 0
    var feedImages: [String]?
    var isReacted = false

    override init() {
        super.init()
    }

    init(response: [String: Any]) {
        super.init()
        if let fullName = response["fullName"] as? String {
            self.fullName = fullName
        }
        avatarURL = response["avatarUrl"] as? String
        if let createAt = response["createAt"] as? String {
            self.createAt = Date.dateFromString(string: createAt,
                format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").timestampString
        }
        if let feedContent = response["feedContent"] as? String {
            self.feedContent = feedContent
        }
        if let visibleMode = response["visibleMode"] as? String {
            self.visibleMode = visibleMode
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
        if let responseImage = response["feedImages"] as? [String] {
            self.feedImages = responseImage
        }
    }

}
