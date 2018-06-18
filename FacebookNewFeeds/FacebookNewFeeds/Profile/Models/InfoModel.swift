//
//  InfoModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/18/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit
private struct Constants {
    public static let workAt = "workAt"
    public static let studiedAt = "studiedAt"
    public static let liveIn = "liveIn"
    public static let from = "from"
}

class InfoModel: NSObject {
    var key: String?
    var value: String?
    var icon: String?

    init(key: String, value: String) {
        super.init()
        self.key = key
        self.value = value
        switch self.key {
        case Constants.workAt:
            self.key = "Work at"
            icon = "ic-work"
        case Constants.studiedAt:
            self.key = "Studied at"
            icon = "ic-study"
        case Constants.liveIn:
            self.key = "Live in"
            icon = "ic-home"
        case Constants.from:
            self.key = "From"
            icon = "ic-location"
        default:
            self.key = ""
            icon = ""
        }
     }

}
