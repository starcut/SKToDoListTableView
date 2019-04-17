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
        // Do any additional setup after loading the view.
        
        for i in 1...4 {
            var element: ToDoListModel = ToDoListModel.init()
            if i%4 == 0 {
                element = ToDoListModel.init(text: String(format: "TODO %00d f\ntest\ntest", i),
                                             priority: .lowPriority,
                                             isCompleted: false,
                                             registerDate: Date.init())
            } else if i%4 == 1 {
                element = ToDoListModel.init(text: String(format: "TODO %00d", i),
                                             priority: .middlePriority,
                                             isCompleted: false,
                                             registerDate: Date.init())
            } else if i%4 == 2 {
                element = ToDoListModel.init(text: String(format: "TODO %00d f\ntest\ntest", i),
                                                                priority: .highPriority,
                                                                isCompleted: false,
                                                                registerDate: Date.init())
            } else {
                element = ToDoListModel.init(text: String(format: "TODO %00d", i),
                                                                priority: .emergencyPriority,
                                                                isCompleted: false,
                                                                registerDate: Date.init())
            }
            self.tableView.appendToDoListArray(element: element)
        }
    }
}

