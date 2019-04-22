//
//  Util.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/22.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

class Util: NSObject {
    static func createDateStringDateAndTime(date: Date, identifier: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd", options: 0, locale: Locale(identifier: identifier))
        return formatter.string(from: date)
    }
    
    static func createTimeStringDateAndTime(date: Date, identifier: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: identifier))
        return formatter.string(from: date)
    }
    
    static func createDate(string: String, identifier: String) -> Date {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd",
                                                        options: 0,
                                                        locale: Locale(identifier: identifier))
        return formatter.date(from: string)!
    }
    
    static func createTime(string: String, identifier: String) -> Date {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm",
                                                        options: 0,
                                                        locale: Locale(identifier: identifier))
        return formatter.date(from: string)!
    }
}
