//
//  PickerEditView.swift
//  PickerEditView
//
//  Created by 清水 脩輔 on 2019/04/19.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit
import FSCalendar

protocol PickerEditViewDelegate {
    // 期日の編集を行うビューの高さを修正する
    func adjustEditViewHeight(height: CGFloat)
    // 期日を変更する
    func changeDate(dateString: String)
    // 期日の時間を変更する
    func changeTime(timeString: String)
}

extension PickerEditViewDelegate {
    // 期日の編集を行うビューの高さを修正する
    func adjustEditViewHeight(height: CGFloat) {}
    // 期日を変更する
    func changeDate(dateString: String) {}
    // 期日の時間を変更する
    func changeTime(timeString: String) {}
}

class PickerEditView: UIView {
    // カレンダー
    @IBOutlet private weak var calendar: FSCalendar!
    // 時間のPicker
    @IBOutlet private weak var timePicker: UIDatePicker!
    // カレンダーのBaseView
    @IBOutlet private weak var calendarBaseView: UIView!
    // 時間のPickerのBaseView
    @IBOutlet private weak var timePickerBaseView: UIView!
    // カレンダーの高さ
    @IBOutlet private weak var calendarHeight: NSLayoutConstraint!
    // 時間のPickerの高さ
    @IBOutlet private weak var timePickerHeight: NSLayoutConstraint!
    
    var delegate: PickerEditViewDelegate?
    // カレンダーのデフォルトの高さ
    private var defaultCalendarHeight: CGFloat = 0.0
    // カレンダーのデフォルトの高さ
    private var defaultTimePickerHeight: CGFloat = 0.0
    
    // MARK: 初期化処理
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        self.calendar.delegate = self
        
        self.defaultCalendarHeight = self.calendarHeight.constant
        self.defaultTimePickerHeight = self.timePickerHeight.constant
        
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = true
    }
    
    // MARK: Public Method
    
    /**
     * カレンダーの表示・非表示を切り替える
     */
    func displayCalendarButton() {
        self.calendarBaseView.isHidden = !self.calendarBaseView.isHidden
        self.timePickerBaseView.isHidden = true
        
        var height: CGFloat = 0.0
        if self.calendarBaseView.isHidden {
            self.calendarHeight.constant = 0.0
        } else {
            self.calendarHeight.constant = self.defaultCalendarHeight
            height = self.calendarHeight.constant
        }
        
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: height)
        }, completion: nil)
    }
    
    /**
     * 時間の変更をするピッカーの表示・非表示を切り替える
     */
    func displayTimePickerButton() {
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = !self.timePickerBaseView.isHidden
        
        var height: CGFloat = 0.0
        if self.timePickerBaseView.isHidden {
            self.timePickerHeight.constant = 0.0
        } else {
            self.timePickerHeight.constant = self.defaultTimePickerHeight
            height = self.timePickerHeight.constant
        }
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: height)
        }, completion: nil)
    }
    
    // MARK: IBAction
    
    /**
     * datePickerの値が変更されたら呼ばれる
     */
    @IBAction private func didValueChangedDatePicker(_ sender: UIDatePicker) {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        self.delegate?.changeTime(timeString: formatter.string(from: sender.date))
    }
}

extension PickerEditView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        self.delegate?.changeDate(dateString: formatter.string(from: date))
    }
}
