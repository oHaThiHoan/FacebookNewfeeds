//
//  AttachImageModel.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/21/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

class AttachImageModel: NSObject {
    var type = ""
    var url = ""

    init(with response: [String: String]) {
        super.init()
        type = response["type"] ?? ""
        url = response["url"] ?? ""
    }

}
