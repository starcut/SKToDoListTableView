//
//  ToDoEditView.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/18.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol ToDoEditViewDelegate {
    // ToDoEditViewを閉じる
    func deleteEditView()
    // 編集した内容を反映させる
    func setEditContents(row: Int, toDoText: String, priority: ToDoPriority, deadline: String)
}

extension ToDoEditViewDelegate {
    // ToDoEditViewを閉じる
    func deleteEditView() {}
    // 編集した内容を反映させる
    func setEditContents(row: Int, toDoText: String, priority: ToDoPriority, deadline: String) {}
}

class ToDoEditView: UIView, PickerEditViewDelegate {
    //ToDo内容
    @IBOutlet weak var toDoTextField: UITextView!
    // 優先度ボタン（低）
    @IBOutlet weak var priorityLowButton: UIButton!
    // 優先度ボタン（中）
    @IBOutlet weak var priorityMiddleButton: UIButton!
    // 優先度ボタン（高）
    @IBOutlet weak var priorityHighButton: UIButton!
    // 優先度ボタン（緊急）
    @IBOutlet weak var priorityEmergencyButton: UIButton!
    // 期限に関して表示させるベースのビュー
    @IBOutlet weak var deadlineBaseView: UIView!
    // 期限に関して表示させるベースのビューの高さ
    @IBOutlet weak var deadlineHeight: NSLayoutConstraint!
    // 期限のカレンダーボタン
    @IBOutlet weak var calendarButton: UIButton!
    // 期限の時間ボタン
    @IBOutlet weak var timeButton: UIButton!
    
    var delegate: ToDoEditViewDelegate?
    
    private var priorityButtons: [UIButton] = []
    // 何番目のセルのデータを編集しているか
    var editingToDoNumber: Int = -1
    // 選択された優先順位
    var selectedPriority: ToDoPriority = .middlePriority
    // 期限のビュー
    var deadlineView: PickerEditView!
    // MARK: 初期化
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override func layoutSubviews() {
        self.priorityButtons = [self.priorityLowButton,
                                self.priorityMiddleButton,
                                self.priorityHighButton,
                                self.priorityEmergencyButton]
        switch self.selectedPriority {
        case .lowPriority:
            self.setConfigSelectedButton(editButton: self.priorityButtons[0], isSelected: true)
            break
        case .middlePriority:
            self.setConfigSelectedButton(editButton: self.priorityButtons[1], isSelected: true)
            break
        case .highPriority:
            self.setConfigSelectedButton(editButton: self.priorityButtons[2], isSelected: true)
            break
        case .emergencyPriority:
            self.setConfigSelectedButton(editButton: self.priorityButtons[3], isSelected: true)
            break
        }
        
        var frame: CGRect = self.deadlineBaseView.bounds
        frame.size = CGSize(width: self.bounds.width, height: self.deadlineBaseView.bounds.height)
        self.deadlineView = PickerEditView.init(frame: frame)
        self.deadlineView.delegate = self
        self.deadlineBaseView.addSubview(self.deadlineView)
    }
    
    // MARK: Private Method
    
    private func commonInit() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setConfigSelectedButton(editButton: UIButton, isSelected: Bool) {
        if isSelected {
            editButton.setTitleColor(.white, for: .normal)
            editButton.backgroundColor = editButton.borderColor
            
            switch editButton.tag {
            case 1:
                self.selectedPriority = .lowPriority
                break
            case 2:
                self.selectedPriority = .middlePriority
                break
            case 3:
                self.selectedPriority = .highPriority
                break
            case 4:
                self.selectedPriority = .emergencyPriority
                break
            default:
                self.selectedPriority = .middlePriority
                break
            }
        } else {
            editButton.setTitleColor(editButton.borderColor, for: .normal)
            editButton.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: IBAction
    
    /**
     * 優先度ボタンをタップした時の処理
     */
    @IBAction private func pushedButton(pushedButton: UIButton) {
        for priorityButton in self.priorityButtons {
            self.setConfigSelectedButton(editButton: priorityButton,
                                         isSelected: (priorityButton.tag == pushedButton.tag))
        }
    }
    
    @IBAction private func pushedCalendarButton() {
        self.deadlineView.displayCalendarButton()
    }
    
    @IBAction private func pushedTimePickerButton() {
        self.deadlineView.displayTimePickerButton()
    }
    
    @IBAction private func pushedCancelButton() {
        self.delegate?.deleteEditView()
    }
    
    @IBAction private func pushedOkButton() {
        self.delegate?.setEditContents(row: self.editingToDoNumber,
                                       toDoText: self.toDoTextField.text!,
                                       priority: self.selectedPriority,
                                       deadline: String.init(format: "%@ %@", (self.calendarButton.titleLabel?.text)!, (self.timeButton.titleLabel?.text)!))
    }
    
    // MARK: PickerEditViewDelegate
    func adjustEditViewHeight(height: CGFloat) {
        self.deadlineBaseView.isHidden = (height == 0)
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.deadlineHeight.constant = height
        }, completion: nil)
    }
    
    func changeDate(dateString: String) {
        self.calendarButton.setTitle(dateString, for: .normal)
    }
    
    func changeTime(timeString: String) {
        self.timeButton.setTitle(timeString, for: .normal)
    }
}
