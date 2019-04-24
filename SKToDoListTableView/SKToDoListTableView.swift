//
//  SKToDoListTableView.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/12.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

open class SKToDoListTableView: UITableView {
    // ToDoリストのセル識別子
    private let TO_DO_LIST_TABLE_VIEW_CELL: String = "SKToDoListTableViewCell"
    // デフォルトのセルの高さ
    private let DEFAULT_CELL_HEIGHT: CGFloat = 66.0
    // ToDoリストの内容を格納した配列
    private var toDoListArray: [ToDoListModel] = []
    // ToDoEditViewを表示する時のグレーのビュー
    private let coverView: UIView = UIView()
    
    // MARK: 初期化処理
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.delegate = self
        self.dataSource = self
        
        // セルの登録
        self.register(UINib(nibName: TO_DO_LIST_TABLE_VIEW_CELL, bundle: nil),
                      forCellReuseIdentifier: TO_DO_LIST_TABLE_VIEW_CELL)
        
        // セルがないところに区切り線を表示させない
        self.tableFooterView = UIView()
        // 区切り線を左端まで伸ばす
        self.separatorInset = .zero
    }
    
    func appendToDoListArray(element: ToDoListModel){
        self.toDoListArray.append(element)
    }
}

// テーブルの内部処理
extension SKToDoListTableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択時の処理
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 左スワイプした時に削除する処理
        if editingStyle == .delete {
            self.toDoListArray.remove(at: indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: {(completed: Bool) in
                tableView.reloadData()
            })
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.toDoListArray[indexPath.row].isExpanded {
            return self.toDoListArray[indexPath.row].textHeight
        }
        return DEFAULT_CELL_HEIGHT
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toDoListArray.count
    }
    
    // セルを表示する
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SKToDoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: TO_DO_LIST_TABLE_VIEW_CELL, for: indexPath) as! SKToDoListTableViewCell
        cell.delegate = self
        cell.setCellConfigure(model: self.toDoListArray[indexPath.row], indexPath: indexPath)
        return cell
    }
}

// セルのステータスによる処理
extension SKToDoListTableView: SKToDoListTableViewCellDelegate {
    /**
     * 全文表示時のセルの高さと行数を設定する
     *
     * - Parameters:
     *  - cell:         セル
     *  - labelHeight:  全文表示時のセルの高さ
     *  - linesNumber:  全文表示時の行数
     */
    func setToDoTextLabelHeight(cell: SKToDoListTableViewCell, labelHeight: CGFloat, linesNumber: Int) {
        self.toDoListArray[cell.indexPath.row].textHeight = labelHeight
        self.toDoListArray[cell.indexPath.row].linesNumber = linesNumber
    }
    
    /**
     * 完了状態を切り替える
     *
     * - Parameters:
     *  - cell:     セル
     */
    func switchCompletionStatus(cell: SKToDoListTableViewCell) {
        self.toDoListArray[cell.indexPath.row].isCompleted = !self.toDoListArray[cell.indexPath.row].isCompleted
        cell.setCellConfigure(model: self.toDoListArray[cell.indexPath.row], indexPath: cell.indexPath)
    }
    
    /**
     * セルの全文表示と一行表示を切り替える
     *
     * - Parameters:
     *  - cell:     セル
     */
    func switchExpandStatus(cell: SKToDoListTableViewCell) {
        self.toDoListArray[cell.indexPath.row].isExpanded = !self.toDoListArray[cell.indexPath.row].isExpanded
        self.performBatchUpdates({
            cell.switchExpandCell(isExpanded: self.toDoListArray[cell.indexPath.row].isExpanded)
        }) { (isFinished) in
            cell.updateCompletion()
        }
    }
    
    /**
     * 編集ボタンたタップされた時の処理
     *
     * - Parameters:
     *  - row:       編集対象のインデックス
     *  - toDoText:  編集対象のテキスト
     *  - priority:  編集対象の優先度
     *  - dealline:  編集対象の期日
     */
    func pushedEditButton(row: Int, toDoText: String, priority: ToDoPriority, dealline: String) {
        self.coverView.frame = UIScreen.main.bounds
        self.coverView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        self.window?.addSubview(self.coverView)
        
        let editViewHorizontalMargin: CGFloat = 16
        let editViewVerticalMargin: CGFloat = 64
        let editViewFrame = CGRect(x: editViewHorizontalMargin,
                                   y: editViewVerticalMargin,
                                   width: self.coverView.frame.width - 2 * editViewHorizontalMargin,
                                   height: self.coverView.frame.height - 2 * editViewVerticalMargin)
        let editView: ToDoEditView = ToDoEditView.init(frame: editViewFrame)
        editView.delegate = self
        editView.editingToDoNumber = row
        editView.toDoTextField.text = toDoText
        editView.selectedPriority = priority
        
        let deadlineArray: [Substring] = dealline.split(separator: " ")
        editView.changeDate(dateString: String(deadlineArray[0]))
        editView.changeTime(timeString: String(deadlineArray[1]))
        self.coverView.addSubview(editView)
    }
}

extension SKToDoListTableView: ToDoEditViewDelegate {
    /**
     * 編集のポップアップを非表示にする
     */
    func deleteEditView() {
        for subview in self.coverView.subviews {
            subview.removeFromSuperview()
        }
        self.coverView.removeFromSuperview()
    }
    
    /**
     * 編集内容を反映させる
     *
     * - Parameters:
     *  - row:       編集対象のインデックス
     *  - toDoText:  編集後のテキスト
     *  - priority:  編集後の優先度
     *  - dealline:  編集後の期日
     */
    func setEditContents(row: Int, toDoText: String, priority: ToDoPriority, deadline: String) {
        self.toDoListArray[row].text = toDoText
        self.toDoListArray[row].priority = priority
        self.toDoListArray[row].deadline = deadline
        self.toDoListArray[row].isExpanded = false
        // テキストの高さをリセットする
        self.toDoListArray[row].textHeight = 0.0
        self.reloadData()
        
        self.deleteEditView()
    }
}
