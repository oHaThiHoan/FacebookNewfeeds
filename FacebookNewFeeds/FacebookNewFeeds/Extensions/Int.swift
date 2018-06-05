//
//  Int.swift
//  FacebookNewFeeds
//
//  Created by ha.thi.hoan on 6/4/18.
//  Copyright © 2018 ha.thi.hoan. All rights reserved.
//

import UIKit

extension Int {

    typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)

    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        let abbreviations: [Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (1000_000.0, 1_000_000.0, "M"),
                                           (1000_000_000.0, 1_000_000_000.0, "B")]
        let startValue = Double (abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        guard let result = numFormatter.string(from: NSNumber (value: value)) else {
            return ""
        }
        return result
    }

}
