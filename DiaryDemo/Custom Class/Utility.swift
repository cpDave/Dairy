//
//  Utility.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import Foundation
extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
        }
        
    }
    func getDaysDifference(_ strDate: String, fromFormat: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        
        if let date = dateFormatter.date(from: strDate) {
            return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
        } else {
            return 0
        }
    }
    static func stringDate(strDate: String, fromFormat: String, toFormat: String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = fromFormat
           if let date = dateFormatter.date(from: strDate) {
               dateFormatter.dateFormat = toFormat
               return dateFormatter.string(from: date)
           }
           return ""
       }
}
