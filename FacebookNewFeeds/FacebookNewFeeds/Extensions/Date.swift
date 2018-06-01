//
//  Date.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 5/31/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension Date {

    static func dateFromString(string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: string) else {
            return Date()
        }
        return date
    }

    func toString(dateFormat: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }

}
