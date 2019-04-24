//
//  ToDoEditView.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/18.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit
import FSCalendar

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

class ToDoEditView: UIView, FSCalendarDelegate {
    @IBOutlet private weak var contentView: UIView!
    //ToDo内容
    @IBOutlet weak var toDoTextField: UITextView!
    // 優先度ボタン（低）
    @IBOutlet private weak var priorityLowButton: UIButton!
    // 優先度ボタン（中）
    @IBOutlet private weak var priorityMiddleButton: UIButton!
    // 優先度ボタン（高）
    @IBOutlet private weak var priorityHighButton: UIButton!
    // 優先度ボタン（緊急）
    @IBOutlet private weak var priorityEmergencyButton: UIButton!
    // カレンダー
    @IBOutlet private weak var calendar: FSCalendar!
    // 時間のPicker
    @IBOutlet private weak var timePicker: UIDatePicker!
    // 期限のカレンダーボタン
    @IBOutlet private weak var calendarButton: UIButton!
    // 期限の時間ボタン
    @IBOutlet private weak var timeButton: UIButton!
    
    @IBOutlet private weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet private weak var timeHeight: NSLayoutConstraint!
    var defaultCalendarHeight: CGFloat!
    var defaultTimeHeight: CGFloat!
    
    var delegate: ToDoEditViewDelegate?
    // 何番目のセルのデータを編集しているか
    var editingToDoNumber: Int = -1
    // 選択された優先順位
    var selectedPriority: ToDoPriority = .middlePriority
    // キーボードのツールバーの高さ
    private let KEYBOARD_TOOL_BAR_HEIGHT: CGFloat = 40
    // 優先度ボタンを格納する配列
    private var priorityButtons: [UIButton] = []
    
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
        self.initializePrioriryButton()
        self.initializeDeadline()
    }
    
    // MARK: Private Method
    
    /**
     * 共通の初期化処理
     */
    private func commonInit() {
        let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        // 最初はカレンダーのみ表示させておく
        self.defaultCalendarHeight = self.calendarHeight.constant
        self.defaultTimeHeight = self.timeHeight.constant
        self.timeHeight.constant = 0.0
        
        // キーボードに完了ボタンを設置する
        self.setToobBarInTextField()
    }
    
    /**
     * テキストフィールドにツールバーをセットする
     */
    private func setToobBarInTextField() {
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0,
                                                y: 0,
                                                width: UIScreen.main.bounds.width,
                                                height: KEYBOARD_TOOL_BAR_HEIGHT))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                     target: self,
                                     action: nil)
        // 閉じるボタン
        let completionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                               target: self,
                                               action: #selector(pushedCompletionButton))
        kbToolBar.items = [spacer, completionButton]
        self.toDoTextField.inputAccessoryView = kbToolBar
    }
    
    /**
     * 完了ボタンをタップした時の処理
     */
    @objc private func pushedCompletionButton() {
        self.endEditing(true)
    }
    
    /**
     * 期日のUIに関する初期化処理
     */
    private func initializeDeadline() {
        self.calendar.delegate = self
        
        
        
        // カレンダーの選択済みの日付を設定
        self.calendar.select(Util.createDate(string: self.calendarButton.titleLabel!.text!,
                                             identifier: "ja_JP"))
        // 期日の時間の初期設定
        self.timePicker.date = Util.createTime(string: self.timeButton.titleLabel!.text!,
                                               identifier: "ja_JP")
        
        
    }
    
    /**
     * 優先度のボタンに関する初期化処理
     * 優先度に対応するボタンは背景色が白、それ以外はその優先度に対応した背景色に設定する
     */
    private func initializePrioriryButton() {
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
    
    /**
     * 優先度ボタンの選択状況の設定を行う
     *
     * - Parameters:
     *  - editButton:   編集対象となる優先度のボタン
     *  - isSelected:   タップされたボタンかどうか
     */
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
            editButton.backgroundColor = UIColor.white
        }
    }
    
    // MARK: IBAction
    
    /**
     * 優先度ボタンをタップした時の処理
     * 選択した優先度のボタンは背景色を対応の色に変更し、それ以外は背景色を白にする
     */
    @IBAction private func pushedButton(pushedButton: UIButton) {
        for priorityButton in self.priorityButtons {
            self.setConfigSelectedButton(editButton: priorityButton,
                                         isSelected: (priorityButton.tag == pushedButton.tag))
        }
    }
    
    /**
     * 日付を変更するボタンをタップした時の処理
     * 時間に関するViewを非表示にし、カレンダーの表示・非表示を切り替える
     */
    @IBAction private func pushedCalendarButton() {
        if self.calendarHeight.constant > 0.0 {
            self.calendarHeight.constant = 0.0
            self.calendar.isHidden = true
        } else {
            self.calendarHeight.constant = self.defaultCalendarHeight
        }
        // 非表示にする際、潰れたtimePickerが見えないようにする
        self.timeHeight.constant = 0.0
        self.timePicker.isHidden = true
        
        UIView.animate(withDuration: ANIMATION_DURATION,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.contentView.layoutSubviews()
        },
                       completion: {(isFinish) in
                        self.calendar.isHidden = !(self.calendarHeight.constant > 0.0)
        })
    }
    
    /**
     * 時間を編集するボタンをタップした時の処理
     * カレンダーを非表示にし、日付のpickerの表示・非表示を切り替える
     */
    @IBAction private func pushedTimePickerButton() {
        self.calendarHeight.constant = 0.0
        self.calendar.isHidden = true
        
        if self.timeHeight.constant > 0.0 {
            self.timeHeight.constant = 0.0
            self.timePicker.isHidden = true
        } else {
            self.timeHeight.constant = self.defaultTimeHeight
        }
        
        UIView.animate(withDuration: ANIMATION_DURATION,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.calendar.isHidden = true
                        self.contentView.layoutSubviews()
        },
                       completion: {(isFinish) in
                        self.timePicker.isHidden = !(self.timeHeight.constant > 0.0)
        })
    }
    
    /**
     * キャンセルボタンをタップした時の処理
     * 変更内容を反映させずに編集ビューを閉じる
     */
    @IBAction private func pushedCancelButton() {
        self.delegate?.deleteEditView()
    }
    
    /**
     * OKボタンをタップした時の処理
     * 変更内容を反映させて編集ビューを閉じる
     */
    @IBAction private func pushedOkButton() {
        self.delegate?.setEditContents(row: self.editingToDoNumber,
                                       toDoText: self.toDoTextField.text!,
                                       priority: self.selectedPriority,
                                       deadline: String.init(format: "%@ %@", (self.calendarButton.titleLabel?.text)!, (self.timeButton.titleLabel?.text)!))
    }
    
    /**
     * datePickerの値が変更されたら呼ばれる
     */
    @IBAction private func didValueChangedDatePicker(_ sender: UIDatePicker) {
        self.changeTime(timeString: Util.createTimeString(date: sender.date, identifier: "ja_JP"))
    }
    
    // MARK: PickerEditViewDelegate
    
    /**
     * 日付の文字列を修正する
     *
     * - Parameters:
     *  - dateString:   期日
     */
    func changeDate(dateString: String) {
        self.calendarButton.setTitle(dateString, for: .normal)
    }
    
    /**
     * 時間の文字列を修正する
     *
     * - Parameters:
     *  - timeString:   期日の時間
     */
    func changeTime(timeString: String) {
        self.timeButton.setTitle(timeString, for: .normal)
    }
    
    // MARK: FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.changeDate(dateString: Util.createDateString(date: date, identifier: "ja_JP"))
    }
}
