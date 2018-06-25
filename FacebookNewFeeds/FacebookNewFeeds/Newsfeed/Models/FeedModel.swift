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
    var feedImages: [AttachModel]?
    var reaction: String?

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
        if let responseImage = response["feedImages"] as? [[String: Any]] {
            feedImages = [AttachModel]()
            for image in responseImage {
                let attachModel = AttachModel(with: image)
                feedImages?.append(attachModel)
            }
        }
        if let reaction = response["reaction"] as? String {
            self.reaction = reaction
        } else {
            reaction = ReactionType.none
        }
    }
    func copy() -> FeedModel {
        let feedModel = FeedModel()
        feedModel.fullName = fullName
        feedModel.avatarURL = avatarURL
        feedModel.createAt = createAt
        feedModel.feedContent = feedContent
        feedModel.visibleMode = visibleMode
        feedModel.reactionCount = reactionCount
        feedModel.commentCount = commentCount
        feedModel.sharingCount = sharingCount
        feedModel.feedImages = feedImages
        feedModel.reaction = reaction
        return feedModel
    }

}
