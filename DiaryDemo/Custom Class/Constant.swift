//
//  Constant.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import Foundation
import Reachability
class constantVC: NSObject {
    static let BaseUrl = "https://private-ba0842-gary23.apiary-mock.com/notes"
    static func formatDateTime(timestamp: String, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = convertFromTimestamp(seconds: timestamp)
        return dateFormatter.string(from: date as Date)
    }
    static func convertFromTimestamp(seconds: String) -> Date {
        let time = (seconds as NSString).doubleValue  // ((seconds as NSString).doubleValue/1000)
        return NSDate(timeIntervalSince1970: TimeInterval(time)) as Date
    }
}
