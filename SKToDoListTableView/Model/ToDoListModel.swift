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
    var text: String
    // ToDoリストの内容の全文表示時のラベルの高さ
    var textHeight: CGFloat = 0.0
    // 優先度
    var priority: ToDoPriority
    // 完了・未完了
    var isCompleted: Bool = false
    // 登録日
    var registerDate: Date = Date.init()
    // ToDoリストの行数
    var linesNumber: Int = 1
    // セルが全文表示されているかどうか
    var isExpanded: Bool = false
    
    // 基本的にこちらは使わない
    override init() {
        self.text = "ToDoの内容が入力されていません"
        self.priority = .middlePriority
        self.registerDate = .init()
    }
    
    // ToDoの登録内容を格納して初期化する
    init(text: String, priority: ToDoPriority, registerDate: Date) {
        self.text = text
        self.priority = priority
        self.registerDate = registerDate
    }
}
