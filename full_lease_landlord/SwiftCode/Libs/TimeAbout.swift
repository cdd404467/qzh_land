//
//  TimeAbout.swift
//  full_lease_landlord
//
//  Created by apple on 2021/2/2.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

enum TimeFormatString: String {
    case year = "yyyy"
    case month = "yyyy-MM"
    case day = "yyyy-MM-dd"
    case hour = "yyyy-MM-dd HH"
    case minute = "yyyy-MM-dd HH:mm"
    case second = "yyyy-MM-dd HH:mm:ss"
}

class Time {
    //Date转String
    @discardableResult
    class func dateToString(date: Date, format: TimeFormatString) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(secondsFromGMT: 8 * 3600)
        formatter.dateFormat = format.rawValue
        let currentDateString: String = formatter.string(from: Date())
        return currentDateString
    }
    
    //String转Date
    @discardableResult
    class func stringToDate(dateStr: String, format: TimeFormatString) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone.init(secondsFromGMT: 8 * 3600)
        let date = formatter.date(from: dateStr)
        return date!
    }
    
    //时间戳转String
    @discardableResult
    class func timeStampToString(timeStamp: Int, format: TimeFormatString) -> String {
        let date: Date = Date.init(timeIntervalSince1970: TimeInterval(timeStamp))
        return dateToString(date: date, format: format)
    }
    
    //String转时间戳
    @discardableResult
    class func stringToTimestamp(dateStr: String, format: TimeFormatString) -> Int {
        let date = stringToDate(dateStr: dateStr, format: format)
        return dateToTimeStamp(date: date)
    }
        
    //Date转时间戳
    @discardableResult
    class func dateToTimeStamp(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    //时间戳转Date
    @discardableResult
    class func timeStampToDate(timeStamp: Int) -> Date {
        if (timeStamp.description.count != 10 || timeStamp.description.count != 13) {
            return Date()
        }
        var value: Int = 0
        if (timeStamp.description.count == 10) {
            value = timeStamp / 1000
        }
        let date = Date.init(timeIntervalSince1970: TimeInterval(value))
        return date
    }
    
}
