//
//  ReactionAsset.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/19/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

public struct ReactionType {
    public static let none = ""
    public static let like = "like"
    public static let love = "love"
    public static let haha = "haha"
    public static let wow = "wow"
    public static let sad = "sad"
    public static let angry = "angry"
}

struct ReactionAsset {
    static let colorAssets = [
        ReactionType.none: UIColor.gray,
        ReactionType.love: UIColor.red,
        ReactionType.like: UIColor.blue,
        ReactionType.haha: UIColor.yellow,
        ReactionType.wow: UIColor.yellow,
        ReactionType.sad: UIColor.yellow,
        ReactionType.angry: UIColor.orange
    ]
    static let iconAssets = [
        ReactionType.none: UIImage(named: "ic-like2"),
        ReactionType.love: UIImage(named: "love"),
        ReactionType.like: UIImage(named: "like"),
        ReactionType.haha: UIImage(named: "haha"),
        ReactionType.wow: UIImage(named: "wow"),
        ReactionType.sad: UIImage(named: "sad"),
        ReactionType.angry: UIImage(named: "angry")
    ]
    static let labelAssets = [
        ReactionType.none: "Like",
        ReactionType.love: "Love",
        ReactionType.like: "Like",
        ReactionType.haha: "Haha",
        ReactionType.wow: "Wow",
        ReactionType.sad: "Sad",
        ReactionType.angry: "Angry"
    ]
}
