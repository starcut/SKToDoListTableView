//
//  ToDoListModel.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/12.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

class ToDoListModel: NSObject {
    // ToDoの優先順位の列挙体
    public enum ToDoPriority: Int {
        case lowPriority = 1
        case middlePriority = 2
        case highPriority = 3
        case emergencyPriority = 4
    }
    
    // ToDoリストの内容
    var text: String = ""
    // ToDoリストの内容の全文表示時のラベルの高さ
    var textHeight: CGFloat = 0.0
    // 優先度
    var priority: ToDoPriority = .middlePriority
    // 完了・未完了
    var isCompleted: Bool = false
    // 登録日
    var registerDate: String = ""
    // 期日
    var deadline: String = ""
    // ToDoリストの行数
    var linesNumber: Int = 1
    // セルが全文表示されているかどうか
    var isExpanded: Bool = false
    // セルを広げることができるかどうか
    var canExpand: Bool = false
    
    // 基本的にこちらは使わない
    override init() {
        super.init()
        
        self.text = "ToDoの内容が入力されていません"
        self.setRegisterAndDeadline(registerDate: Date(), deadline: nil)
    }
    
    // ToDoの登録内容を格納して初期化する
    init(text: String, priority: ToDoPriority, registerDate: Date, deadline: Date!) {
        super.init()
        
        self.text = text
        self.priority = priority
        self.setRegisterAndDeadline(registerDate: registerDate, deadline: deadline)
    }
    
    /**
     * 登録日、期限の設定を行う
     *
     * - Parameters:
     *  - registerDate: 登録日
     *  - deadline:     期限
     */
    fileprivate func setRegisterAndDeadline(registerDate: Date, deadline: Date!) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        self.registerDate = formatter.string(from: registerDate)
        
        // 期日が設定されなかった場合は、登録した月の末日に設定
        if (deadline == nil) {
            let calendar: Calendar = Calendar.current
            var comp = calendar.dateComponents([.year, .month], from: Date())
            
            // 月初の0時0分0秒に設定
            comp.hour = 23
            comp.minute = 59
            
            // その月が何日あるかを計算し、最終日を設定
            let range = calendar.range(of: .day, in: .month, for: Date())
            comp.day = range?.count
            
            // Dateを作成
            self.deadline = formatter.string(from: calendar.date(from: comp)!)
        } else {
            self.deadline = formatter.string(from: deadline)
        }
    }
}
