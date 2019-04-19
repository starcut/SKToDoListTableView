//
//  ToDoEditView.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/18.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol ToDoEditViewDelegate {
    func deleteEditView()
}

extension ToDoEditViewDelegate {
    func deleteEditView() {}
}

class ToDoEditView: UIView {
    //ToDo内容
    @IBOutlet weak var toDoTextField: UITextField!
    // 優先度ボタン（低）
    @IBOutlet weak var priorityLowButton: UIButton!
    // 優先度ボタン（中）
    @IBOutlet weak var priorityMiddleButton: UIButton!
    // 優先度ボタン（高）
    @IBOutlet weak var priorityHighButton: UIButton!
    // 優先度ボタン（緊急）
    @IBOutlet weak var priorityEmergencyButton: UIButton!
    
    var delegate: ToDoEditViewDelegate?
    
    private var priorityButtons: [UIButton] = []
    
    var selectedPriority: ToDoPriority = .middlePriority
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
    
    @IBAction private func pushedCancelButton() {
        self.delegate?.deleteEditView()
    }
    
    @IBAction private func pushedOkButton() {
        self.delegate?.deleteEditView()
    }
}
