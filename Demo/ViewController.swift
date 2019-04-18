//
//  ViewController.swift
//  Demo
//
//  Created by 清水 脩輔 on 2019/04/12.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit
import SKToDoListTableView

class ViewController: UIViewController {
    @IBOutlet weak var tableView: SKToDoListTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...100 {
            var element: ToDoListModel = ToDoListModel.init()
            if i%4 == 0 {
                element = ToDoListModel.init(text: String(format: "TODO %00d f\n\n\n\ntest", i),
                                             priority: .lowPriority,
                                             registerDate: Date.init())
            } else if i%4 == 1 {
                element = ToDoListModel.init(text: String(format: "TODO %00d", i),
                                             priority: .middlePriority,
                                             registerDate: Date.init())
            } else if i%4 == 2 {
                element = ToDoListModel.init(text: String(format: "TODO %00d f\ntesttest", i),
                                                                priority: .highPriority,
                                                                registerDate: Date.init())
            } else {
                element = ToDoListModel.init(text: String(format: "TODO %00d", i),
                                                                priority: .emergencyPriority,
                                                                registerDate: Date.init())
            }
            self.tableView.appendToDoListArray(element: element)
        }
    }
}

