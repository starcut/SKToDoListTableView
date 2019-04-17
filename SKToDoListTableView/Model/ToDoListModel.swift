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
    // 優先度
    var priority: ToDoPriority
    // 完了・未完了
    var isCompleted: Bool
    // 登録日
    var registerDate: Date
    
    // 基本的にこちらは使わない
    override init() {
        self.text = "ToDoの内容が入力されていません"
        self.priority = .middlePriority
        self.isCompleted = false
        self.registerDate = .init()
    }
    
    // ToDoの登録内容を格納して初期化する
    init(text: String, priority: ToDoPriority, isCompleted: Bool, registerDate: Date) {
        self.text = text
        self.priority = priority
        self.isCompleted = isCompleted
        self.registerDate = registerDate
    }
}
