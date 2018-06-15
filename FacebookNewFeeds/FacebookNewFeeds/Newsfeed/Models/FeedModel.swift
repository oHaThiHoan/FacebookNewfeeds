//
//  FeedModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/30/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
import Reactions

public struct ReactionType {
    public static let none = ""
    public static let like = "like"
    public static let love = "love"
    public static let haha = "haha"
    public static let wow = "wow"
    public static let sad = "sad"
    public static let angry = "angry"
}

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
    var reaction: Reaction?

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
        if let reaction = response["reaction"] as? String, reaction != ReactionType.none {
            self.reaction = convertStringToReactionType(string: reaction)
        }
    }

    func convertStringToReactionType(string: String) -> Reaction {
        switch string {
        case ReactionType.none:
            return Reaction(id: "", title: "", color: .clear, icon: UIImage())
        case ReactionType.like:
            return Reaction.facebook.like
        case ReactionType.love:
            return Reaction.facebook.love
        case ReactionType.haha:
            return Reaction.facebook.haha
        case ReactionType.wow:
            return Reaction.facebook.wow
        case ReactionType.angry:
            return Reaction.facebook.angry
        case ReactionType.sad:
            return Reaction.facebook.sad
        default:
            return Reaction(id: "", title: "", color: .clear, icon: UIImage())
        }
    }

}
