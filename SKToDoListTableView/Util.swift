//
//  Util.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/22.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

class Util: NSObject {
    /**
     * Dateから日時の文字列を取得する
     *
     * - Parameters:
     *  - date:         日付
     *  - identifier:   地域の識別子
     */
    static func createDateTimeString(date: Date, identifier: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd HH:mm", options: 0, locale: Locale(identifier: identifier))
        return formatter.string(from: date)
    }
    
    /**
     * Dateから日付の文字列を取得する
     *
     * - Parameters:
     *  - date:         日付
     *  - identifier:   地域の識別子
     */
    static func createDateString(date: Date, identifier: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd", options: 0, locale: Locale(identifier: identifier))
        return formatter.string(from: date)
    }
    
    /**
     * Dateから時刻の文字列を取得する
     *
     * - Parameters:
     *  - date:         日付
     *  - identifier:   地域の識別子
     */
    static func createTimeString(date: Date, identifier: String) -> String {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: identifier))
        return formatter.string(from: date)
    }
    
    /**
     * 文字列からDate型の日付を取得する
     *
     * - Parameters:
     *  - date:         日付
     *  - identifier:   地域の識別子
     */
    static func createDate(string: String, identifier: String) -> Date {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd",
                                                        options: 0,
                                                        locale: Locale(identifier: identifier))
        return formatter.date(from: string)!
    }
    
    /**
     * 文字列からDate型の時刻を取得する
     *
     * - Parameters:
     *  - date:         日付
     *  - identifier:   地域の識別子
     */
    static func createTime(string: String, identifier: String) -> Date {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm",
                                                        options: 0,
                                                        locale: Locale(identifier: identifier))
        return formatter.date(from: string)!
    }
}
