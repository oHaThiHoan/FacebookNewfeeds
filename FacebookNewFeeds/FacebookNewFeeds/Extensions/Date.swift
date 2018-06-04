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

    var timestampString: String? {
        guard let diffInDays = Calendar.current.dateComponents([.day], from: self, to: Date()).day else {
            return nil
        }
        if diffInDays > 1 {
            return self .toString(dateFormat: "MMM d, h:mm a")
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 1
            formatter.allowedUnits = [.hour, .minute, .second]
            guard let timeString = formatter.string(from: self, to: Date()) else {
                return nil
            }
            let formatString = NSLocalizedString("%@ ago", comment: "")
            return String(format: formatString, timeString)
        }
    }

}
