//
//  String.swift
//  zScanner
//
//  Created by Jakub Skořepa on 29/06/2019.
//  Copyright © 2019 Institut klinické a experimentální medicíny. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return localized(withComment: "")
    }
    
    func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    /* if the personal identification number (PIN - YYMMDD/___?) a has length equal to 9 so year must be 53 and less othewise length has to be 10 */
    func isPIN() -> Bool {
        guard let year = Int(self.prefix(2)) else { return false }
        let newFormatYear = 54
        let oldFormat = 9
        let newFormat = 10
        return (year < newFormatYear && length == oldFormat) || (year >= newFormatYear && length == newFormat)
    }
}
